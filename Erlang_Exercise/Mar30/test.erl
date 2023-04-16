-module(test).
-compile(export_all).
-compile(nowarn_export_all).

producer(S) ->
    startProduce(S),
    timer:sleep(1000),
    stopProduce(S).

startProduce(S) ->
    S ! {self(), start_produce},
    receive
        {ok} ->
            ok
    end.

stopProduce(S) ->
    S ! {stop_produce}.

resource(Size, Cap, P, C) ->
    receive
        {From, start_produce} when Size + P < Cap ->
            From ! {ok},
            resource(Size, Cap, P + 1, C);
        {stop_produce} ->
            resource(Size + 1, Cap, P - 1, C);
        {From, start_consume} when Size - C > 0 ->
            From ! {ok},
            resource(Size, Cap, P, C + 1);
        {stop_consume} ->
            resource(Size - 1, Cap, P, C - 1)
    end.

start(Cap, P, C) ->
    DC = spawn(?MODULE, resource, [0, Cap, 0, 0]),
    [spawn(?MODULE, producer, [DC]) || _ <- lists:seq(1, P)],
    [spawn(?MODULE, consumer, [DC]) || _ <- lists:seq(1, C)].
