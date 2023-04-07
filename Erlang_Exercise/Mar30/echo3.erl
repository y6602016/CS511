-module(echo3).
-compile(export_all).

%%% two clients, one server
%%% single echo server, using make_ref() and passing ref when sending message
%%% to the server, then we can identify the call when we receive echo from the server

echo() ->
    receive
        {From, Ref, Msg} ->
            timer:sleep(rand:uniform(1000)),
            From ! {self(), Ref, Msg},
            echo();
        stop ->
            ok
    end.

start() ->
    P = spawn(?MODULE, echo, []),
    Token = 42,
    Ref = make_ref(),
    P ! {self(), Ref, Token},
    io:fwrite("Sent ~w~n", [Token]),
    Ref2 = make_ref(),
    Token2 = 12,
    P ! {self(), Ref2, Token2},
    io:fwrite("Sent ~w~n", [Token2]),

    %%% using Ref and Ref2 to identify pattern match
    receive
        {P, Ref, Msg} -> io:fwrite("Received ~w~n", [Msg]);
        {P, Ref2, Msg} -> io:fwrite("Received ~w~n", [Msg])
    end,

    P ! stop.
