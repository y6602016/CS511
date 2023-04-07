-module(echo2).
-compile([export_all]).

%%% one client, two servers
%%% multiple echo servers, let the servers returning their PID to identify servers

echo() ->
    receive
        {From, Msg} ->
            timer:sleep(rand:uniform(100)),
            From ! {self(), Msg},
            echo();
        stop ->
            true
    end.

start() ->
    PidB = spawn(?MODULE, echo, []),
    PidC = spawn(?MODULE, echo, []),
    Token = 42,
    PidB ! {self(), Token},
    io:fwrite("Sent~w~n", [Token]),
    Token2 = 33,
    PidC ! {self(), Token2},
    io:fwrite("Sent~w~n", [Token2]),

    %%% receive like consume! once receive, one of them then leave the receive statement and stop both
    receive
        {PidB, Msg} ->
            io:fwrite("Received from B ~w~n", [Msg]);
        {PidC, Msg} ->
            io:fwrite("Received from C ~w~n", [Msg])
    end,

    PidB ! stop,
    PidC ! stop.
