-module(server).
-export([start_server/0]).
-include_lib("./defs.hrl").
-author("Qi-Rui Hong").

-spec start_server() -> _.
-spec loop(_State) -> _.
-spec do_join(_ChatName, _ClientPID, _Ref, _State) -> _.
-spec do_leave(_ChatName, _ClientPID, _Ref, _State) -> _.
-spec do_new_nick(_State, _Ref, _ClientPID, _NewNick) -> _.
-spec do_client_quit(_State, _Ref, _ClientPID) -> _NewState.

start_server() ->
    catch (unregister(server)),
    register(server, self()),
    case whereis(testsuite) of
        undefined -> ok;
        TestSuitePID -> TestSuitePID ! {server_up, self()}
    end,
    loop(
        #serv_st{
            %% nickname map. client_pid => "nickname"
            nicks = maps:new(),
            %% registration map. "chat_name" => [client_pids]
            registrations = maps:new(),
            %% chatroom map. "chat_name" => chat_pid
            chatrooms = maps:new()
        }
    ).

loop(State) ->
    receive
        %% initial connection
        {ClientPID, connect, ClientNick} ->
            NewState =
                #serv_st{
                    nicks = maps:put(ClientPID, ClientNick, State#serv_st.nicks),
                    registrations = State#serv_st.registrations,
                    chatrooms = State#serv_st.chatrooms
                },
            loop(NewState);
        %% client requests to join a chat
        {ClientPID, Ref, join, ChatName} ->
            NewState = do_join(ChatName, ClientPID, Ref, State),
            loop(NewState);
        %% client requests to join a chat
        {ClientPID, Ref, leave, ChatName} ->
            NewState = do_leave(ChatName, ClientPID, Ref, State),
            loop(NewState);
        %% client requests to register a new nickname
        {ClientPID, Ref, nick, NewNick} ->
            NewState = do_new_nick(State, Ref, ClientPID, NewNick),
            loop(NewState);
        %% client requests to quit
        {ClientPID, Ref, quit} ->
            NewState = do_client_quit(State, Ref, ClientPID),
            loop(NewState);
        {TEST_PID, get_state} ->
            TEST_PID ! {get_state, State},
            loop(State)
    end.

%% executes join protocol from server perspective
do_join(ChatName, ClientPID, Ref, State) ->
    % he server needs to check if the chatroom exists yet
    case maps:find(ChatName, State#serv_st.chatrooms) of
        % If the chatroom does not yet exist, the server must spawn the chatroom.
        error ->
            ChatRoomPID = spawn(chatroom, start_chatroom, [ChatName]),
            % add the new chatroom to the chatroom map
            Chatrooms = maps:put(ChatName, ChatRoomPID, State#serv_st.chatrooms),
            % add the new chatroom and the clirnt to the registrations map
            Registrations = maps:put(ChatName, [ClientPID], State#serv_st.registrations);
        {ok, PID} ->
            ChatRoomPID = PID,
            % retrieve the chatroom map
            Chatrooms = State#serv_st.chatrooms,
            % update the registration list of the chatroom, appending the client to the front of the list
            CurrentRegisters = maps:get(ChatName, State#serv_st.registrations),
            Registrations = maps:update(
                ChatName, [ClientPID | CurrentRegisters], State#serv_st.registrations
            )
    end,

    % the server should look up the client’s nickname from the server’s serv st record
    ClientNick = maps:get(ClientPID, State#serv_st.nicks),

    % the server must tell the chatroom that the client is joining the chatroom.
    ChatRoomPID ! {self(), Ref, register, ClientPID, ClientNick},

    % server will then update its record of chatroom registrations to include the client in the list of clients registered to that chatroom.
    NewState = State#serv_st{
        registrations = Registrations,
        chatrooms = Chatrooms
    },
    NewState.

%% executes leave protocol from server perspective
do_leave(ChatName, ClientPID, Ref, State) ->
    %the server will lookup the chatroom’s PID from the server’s state serv_st
    ChatRoomPID = maps:get(ChatName, State#serv_st.chatrooms),

    % the server will remove the client from its local record of chatroom registrations
    CurrentRegisters = maps:get(ChatName, State#serv_st.registrations),
    NewState = State#serv_st{
        registrations = maps:update(
            ChatName, CurrentRegisters -- [ClientPID], State#serv_st.registrations
        )
    },

    % the server will send the message to the chatroom
    ChatRoomPID ! {self(), Ref, unregister, ClientPID},

    % the server will then send the message back to the client
    ClientPID ! {self(), Ref, ack_leave},
    NewState.

%% executes new nickname protocol from server perspective
do_new_nick(State, Ref, ClientPID, NewNick) ->
    % the server first needs to check if the new nickname Nick is already used
    case lists:member(NewNick, maps:values(State#serv_st.nicks)) of
        % If the nickname is already in use by another client, the server will send the err to the client
        true ->
            ClientPID ! {self(), Ref, err_nick_used},
            State;
        false ->
            % the new nickname Nick is free to be used, the server update it’s record of nicknames
            NewState = State#serv_st{nicks = maps:update(ClientPID, NewNick, State#serv_st.nicks)},
            % the server updates all chatrooms to which the client belongs by sending message
            maps:foreach(
                fun(ChatName, ClientPids) ->
                    case lists:member(ClientPID, ClientPids) of
                        % if this chatroom contains the client, send message to the chatroom
                        true ->
                            ChatRoomPID = maps:get(ChatName, State#serv_st.chatrooms),
                            ChatRoomPID ! {self(), Ref, update_nick, ClientPID, NewNick};
                        false ->
                            ok
                    end
                end,
                State#serv_st.registrations
            ),
            ClientPID ! {self(), Ref, ok_nick},
            NewState
    end.

%% executes client quit protocol from server perspective
do_client_quit(State, Ref, ClientPID) ->
    % remove client from nicknames
    NewNicks = maps:remove(ClientPID, State#serv_st.nicks),

    % tell each chatroom to which the client is registered that the client is leaving
    maps:foreach(
        fun(ChatName, ClientPids) ->
            case lists:member(ClientPID, ClientPids) of
                % if this chatroom contains the client, send message to the chatroom
                true ->
                    ChatRoomPID = maps:get(ChatName, State#serv_st.chatrooms),
                    ChatRoomPID ! {self(), Ref, unregister, ClientPID};
                false ->
                    ok
            end
        end,
        State#serv_st.registrations
    ),

    % remove client from the server’s copy of all chat registrations
    NewRegistrations = maps:map(
        fun(_ChatName, ClientPids) ->
            case lists:member(ClientPID, ClientPids) of
                % if this chatroom contains the client, remove the clientPID from the PID list
                true ->
                    ClientPids -- [ClientPID];
                false ->
                    ClientPids
            end
        end,
        State#serv_st.registrations
    ),

    % The server must then send the message to the client
    ClientPID ! {self(), Ref, ack_quit},
    NewState = State#serv_st{nicks = NewNicks, registrations = NewRegistrations},
    NewState.
