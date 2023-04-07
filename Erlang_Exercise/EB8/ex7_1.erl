-module(ex7_1).
-compile(export_all).

start(P, J) ->
    S = spawn(?MODULE, server, [0]),
    [spawn(?MODULE, patriots, [S]) || _ <- lists:seq(1, P)],
    [spawn(?MODULE, jets, [S]) || _ <- lists:seq(1, J)].

patriots(S) ->
    S ! {self(), patriot}.

jets(S) ->
    R = make_ref(),
    S ! {self(), R, jet},
    receive
        {S, R, ok} -> ok
    end.

server(Patriots) ->
    receive
        {_From, patriot} ->
            io:fwrite("p~n"),
            server(Patriots + 1);
        {From, R, jet} when Patriots > 1 ->
            io:fwrite("j~n"),
            From ! {self(), R, ok},
            server(Patriots - 2)
    end.
