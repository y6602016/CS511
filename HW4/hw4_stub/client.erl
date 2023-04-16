-module(client).

-export([main/1, initial_state/2]).

-include_lib("./defs.hrl").

-spec main(_InitialState) -> _.
-spec listen(_State) -> _.
-spec initial_state(_Nick, _GuiName) -> _InitialClientState.
-spec loop(_State, _Request, _Ref) -> _.
-spec do_join(_State, _Ref, _ChatName) -> _.
-spec do_leave(_State, _Ref, _ChatName) -> _.
-spec do_new_nick(_State, _Ref, _NewNick) -> _.
-spec do_new_incoming_msg(_State, _Ref, _SenderNick, _ChatName, _Message) -> _.

%% Receive messages from GUI and handle them accordingly
%% All handling can be done in loop(...)
main(InitialState) ->
    %% The client tells the server it is connecting with its initial nickname.
    %% This nickname is guaranteed unique system-wide as long as you do not assign a client
    %% the nickname in the form "user[number]" manually such that a new client happens
    %% to generate the same random number as you assigned to your client.
    whereis(server) ! {self(), connect, InitialState#cl_st.nick},
    %% if running test suite, tell test suite that client is up
    case whereis(testsuite) of
        undefined -> ok;
        TestSuitePID -> TestSuitePID ! {client_up, self()}
    end,
    %% Begins listening
    listen(InitialState).

%% This method handles all incoming messages from either the GUI or the
%% chatrooms that are not directly tied to an ongoing request cycle.
listen(State) ->
    receive
        {request, From, Ref, Request} ->
            %% the loop method will return a response as well as an updated
            %% state to pass along to the next cycle
            {Response, NextState} = loop(State, Request, Ref),
            case Response of
                {dummy_target, Resp} ->
                    io:format("Use this for whatever you would like~n"),
                    From ! {result, self(), Ref, {dummy_target, Resp}},
                    listen(NextState);
                %% if shutdown is received, terminate
                shutdown ->
                    ok_shutdown;
                %% if ok_msg_received, then we don't need to reply to sender.
                ok_msg_received ->
                    listen(NextState);
                %% otherwise, reply to sender with response
                _ ->
                    From ! {result, self(), Ref, Response},
                    listen(NextState)
            end
    end.

%% This function just initializes the default state of a client.
%% This should only be used by the GUI. Do not change it, as the
%% GUI code we provide depends on it.
initial_state(Nick, GUIName) ->
    #cl_st{gui = GUIName, nick = Nick, con_ch = maps:new()}.

%% ------------------------------------------
%% loop handles each kind of request from GUI
%% ------------------------------------------
loop(State, Request, Ref) ->
    case Request of
        %% GUI requests to join a chatroom with name ChatName
        {join, ChatName} ->
            do_join(State, Ref, ChatName);
        %% GUI requests to leave a chatroom with name ChatName
        {leave, ChatName} ->
            do_leave(State, Ref, ChatName);
        %% GUI requests to send an outgoing message Message to chatroom ChatName
        {outgoing_msg, ChatName, Message} ->
            do_msg_send(State, Ref, ChatName, Message);
        %% GUI requests the nickname of client
        whoami ->
            Nickname = State#cl_st.nick,
            {Nickname, State};
        %% GUI requests to update nickname to Nick
        {nick, Nick} ->
            do_new_nick(State, Ref, Nick);
        %% GUI requesting to quit completely
        quit ->
            do_quit(State, Ref);
        %% Chatroom with name ChatName has sent an incoming message Message
        %% from sender with nickname SenderNick
        {incoming_msg, SenderNick, ChatName, Message} ->
            do_new_incoming_msg(State, Ref, SenderNick, ChatName, Message);
        {get_state} ->
            {{get_state, State}, State};
        %% Somehow reached a state where we have an unhandled request.
        %% Without bugs, this should never be reached.
        _ ->
            io:format("Client: Unhandled Request: ~w~n", [Request]),
            {unhandled_request, State}
    end.

%% executes `/join` protocol from client perspective
do_join(State, Ref, ChatName) ->
    % the client checks in its cl st record to see if it is already in the chatroom.
    case maps:is_key(ChatName, State#cl_st.con_ch) of
        true ->
            % If the client is already in the chatroom identified by ChatName, returns err
            {err, State};
        false ->
            % the client is not currently in the chatroom, the client should ask the server to join said chatroom.
            whereis(server) ! {self(), Ref, join, ChatName},
            % the client waits for receiving response from the Chatroom process
            receive
                {From, Ref, connect, History} ->
                    % update its record of connected chatrooms
                    NewState = State#cl_st{con_ch = maps:put(ChatName, From, State#cl_st.con_ch)},
                    % return the history of the new-join chatroom and the new state
                    {History, NewState}
            end
    end.

%% executes `/leave` protocol from client perspective
do_leave(State, Ref, ChatName) ->
    % the client needs to check that it is in the chatroom with the name ChatName
    case maps:is_key(ChatName, State#cl_st.con_ch) of
        % if the chatroom is not found in the client’s list of connected chatrooms, return err
        false ->
            {err, State};
        true ->
            % if the chatroom is found, then the client should send the message to the server
            whereis(server) ! {self(), Ref, leave, ChatName},
            % the client waits for receiving response from the server
            receive
                {_From, Ref, ack_leave} ->
                    % the client will then remove the chatroom from its list of chatrooms
                    NewState = State#cl_st{con_ch = maps:remove(ChatName, State#cl_st.con_ch)},
                    % The client will then send the message back to the GUI
                    {ok, NewState}
            end
    end.

%% executes `/nick` protocol from client perspective
do_new_nick(State, Ref, NewNick) ->
    % the client should check Nick against its current nickname
    case NewNick == State#cl_st.nick of
        % if the client finds that Nick is the same as current nickname, then the client should send err
        true ->
            {err_same, State};
        false ->
            % if client finds that Nick is not the same as current nickname, then the client will send a message to the server
            whereis(server) ! {self(), Ref, nick, NewNick},
            % the client waits for the response from the server
            receive
                % if the new name is used by another client, return err to GUI
                {_From, Ref, err_nick_used} ->
                    {err_nick_used, State};
                % get ok from the server, the client can update it's state
                {_From, Ref, ok_nick} ->
                    % update current nickname
                    NewState = State#cl_st{nick = NewNick},
                    % the client will then send the message back to the GUI
                    {ok_nick, NewState}
            end
    end.

%% executes send message protocol from client perspective
do_msg_send(State, Ref, ChatName, Message) ->
    io:format("client:do_new_nick(...): IMPLEMENT ME~n"),
    {{dummy_target, dummy_response}, State}.

%% executes new incoming message protocol from client perspective
do_new_incoming_msg(State, _Ref, CliNick, ChatName, Msg) ->
    %% pass message along to gui
    gen_server:call(list_to_atom(State#cl_st.gui), {msg_to_GUI, ChatName, CliNick, Msg}),
    {ok_msg_received, State}.

%% executes quit protocol from client perspective
do_quit(State, Ref) ->
    io:format("client:do_new_nick(...): IMPLEMENT ME~n"),
    {{dummy_target, dummy_response}, State}.
