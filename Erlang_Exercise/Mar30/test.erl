-module(test).
-compile(export_all).

cleaner(C, D) ->
    receive
        {drop} ->
            cleaner(C, D + 1);
        {From, ready} when D > 0 ->
            From ! {self(), ok},
            cleaner(C + 1, D - 1);
        {From, picj} when C > 0 ->
            From ! {self(), ok},
            cleaner(C - 1, D)
    end.

e(S) ->
    S ! {drop},
    S ! {self(), pick},
    receive
        {S, ok} -> ok
    end.

c(S) ->
    S ! {self(), ready},
    receive
        {S, ok} ->
            timer:sleep(1000),
            ok
    end.

start(C, D) ->
    S = spawn(?MODULE, cleaner, [C, D]),
    [spawn(?MODULE, e, [S]) || _ <- lists:seq(1, C)],
    [spawn(?MODULE, e, [S]) || _ <- lists:seq(1, D)].
