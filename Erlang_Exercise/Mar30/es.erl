-module(es).
-compile(export_all).
%%% http://geekhmer.github.io/blog/2015/01/27/erlang-message-passing/
%%% S=es:start().
%%% <0.92.0> // which is the program PID
%%% S!{self(), "hello"} // A!B = send message B to A
%%% {<0.81.0>,"hello"}, which is what we send to echo server, 81 is the self PID
%%% flush() which us used to see mailbox

echo() ->
    receive
        %%% pattern 1
        {From, Msg} ->
            From ! {Msg},
            echo();
        %%% pattern 2
        stop ->
            ok
    end.

start() ->
    %%% spawn() creates a new process and returns the pid
    % spawn(?MODULE, echo, []).
    Pid = spawn(?MODULE, echo, []),
    Token = "Hello Server",
    Pid ! {self(), Token},
    io:fwrite("Sent ~s~n", [Token]),
    receive
        {Msg} ->
            io:fwrite("Received ~s~n", [Msg])
    end,
    Pid ! stop.
