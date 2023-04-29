-module(chatroom).
-include_lib("./defs.hrl").
-export([start_chatroom/1]).
-author("Qi-Rui Hong").

-spec start_chatroom(_ChatName) -> _.
-spec loop(_State) -> _.
-spec do_register(_State, _Ref, _ClientPID, _ClientNick) -> _NewState.
-spec do_unregister(_State, _ClientPID) -> _NewState.
-spec do_update_nick(_State, _ClientPID, _NewNick) -> _NewState.
-spec do_propegate_message(_State, _Ref, _ClientPID, _Message) -> _NewState.

start_chatroom(ChatName) ->
    loop(#chat_st{
        name = ChatName,
        registrations = maps:new(),
        history = []
    }),
    ok.

loop(State) ->
    NewState =
        receive
            %% Server tells this chatroom to register a client
            {_ServerPID, Ref, register, ClientPID, ClientNick} ->
                do_register(State, Ref, ClientPID, ClientNick);
            %% Server tells this chatroom to unregister a client
            {_ServerPID, _Ref, unregister, ClientPID} ->
                do_unregister(State, ClientPID);
            %% Server tells this chatroom to update the nickname for a certain client
            {_ServerPID, _Ref, update_nick, ClientPID, NewNick} ->
                do_update_nick(State, ClientPID, NewNick);
            %% Client sends a new message to the chatroom, and the chatroom must
            %% propegate to other registered clients
            {ClientPID, Ref, message, Message} ->
                do_propegate_message(State, Ref, ClientPID, Message);
            {TEST_PID, get_state} ->
                TEST_PID ! {get_state, State},
                loop(State)
        end,
    loop(NewState).

%% This function should register a new client to this chatroom
do_register(State, Ref, ClientPID, ClientNick) ->
    % the chatroom will update its local record of registered clients
    NewState = State#chat_st{
        registrations = maps:put(ClientPID, ClientNick, State#chat_st.registrations)
    },
    % the chatroom will tell the client about itself
    ClientPID ! {self(), Ref, connect, State#chat_st.history},
    NewState.

%% This function should unregister a client from this chatroom
do_unregister(State, ClientPID) ->
    % the chatroom will remove the client from its record of registered clients.
    NewState = State#chat_st{
        registrations = maps:remove(ClientPID, State#chat_st.registrations)
    },
    NewState.

%% This function should update the nickname of specified client.
do_update_nick(State, ClientPID, NewNick) ->
    NewState = State#chat_st{
        registrations = maps:update(ClientPID, NewNick, State#chat_st.registrations)
    },
    NewState.

%% This function should update all clients in chatroom with new message
%% (read assignment specs for details)
do_propegate_message(State, Ref, ClientPID, Message) ->
    % the chatroom will then send back to the sending client the message
    ClientPID ! {self(), Ref, ack_msg},

    % The chatroom will send a message to each receiving client registered to the
    % chatroom except for the sending client
    ReceivingList = maps:keys(State#chat_st.registrations) -- [ClientPID],
    CliNick = maps:get(ClientPID, State#chat_st.registrations),
    [
        PID ! {request, self(), Ref, {incoming_msg, CliNick, State#chat_st.name, Message}}
     || PID <- ReceivingList
    ],

    % the chatroom will then append the new Message to its own chat history
    NewState = State#chat_st{history = State#chat_st.history ++ [{CliNick, Message}]},
    NewState.
