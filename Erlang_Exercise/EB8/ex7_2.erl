-module(ex7_2).
-compile(export_all).

start(P, J) ->
    S = spawn(?MODULE, server, [0, false]),
    [spawn(?MODULE, patriots, [S]) || _ <- lists:seq(1, P)],
    [spawn(?MODULE, jets, [S]) || _ <- lists:seq(1, J)],
    spawn(?MODULE, isLate, [3000, S]).

isLate(Time, S) ->
    timer:sleep(Time),
    R = make_ref(),
    S ! {self(), R, late},
    receive
        {S, R, ok} -> ok
    end.

patriots(S) ->
    S ! {self(), patriot}.

jets(S) ->
    R = make_ref(),
    S ! {self(), R, jet},
    receive
        {S, R, ok} -> ok
    end.

server(Patriots, true) ->
    receive
        {_From, patriot} ->
            io:fwrite("p~n"),
            server(Patriots + 1, true);
        {From, R, jet} ->
            io:fwrite("j~n"),
            From ! {self(), R, ok},
            server(Patriots, true)
    end;
server(Patriots, false) ->
    receive
        {_From, patriot} ->
            io:fwrite("p~n"),
            server(Patriots + 1, false);
        {From, R, jet} when Patriots > 1 ->
            io:fwrite("j~n"),
            From ! {self(), R, ok},
            server(Patriots - 2, false);
        {From, R, late} ->
            io:fwrite("late~n"),
            server(Patriots, true)
    end.
