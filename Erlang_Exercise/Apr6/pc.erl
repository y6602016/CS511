-module(pc).
-compile(nowarn_export_all).
-compile(export_all).

start(Cap, P, C) ->
    RS = spawn(?MODULE, resource, [0, Cap, 0, 0]),
    [spawn(?MODULE, producer, [RS]) || _ <- lists:seq(1, P)],
    [spawn(?MODULE, producer, [RS]) || _ <- lists:seq(1, C)].

producer(RS) ->
    RS ! {startProduce, self()},
    receive
        {ok} -> ok
    end,
    time:sleep(rand:uniform(100)),
    RS ! {stopProduce}.

resource(Size, Capacity, SP, SC) ->
    receive
        {startProduce, From} when Size + SP < Capacity ->
            From ! {ok},
            resource(Size, Capacity, SP + 1, SC);
        {stopProduce} ->
            resource(Size + 1, Capacity, SP - 1, SC);
        {startConsume, From} when Size - SC > 0 ->
            From ! {ok},
            resource(Size, Capacity, SP, SC + 1);
        {stopConsume} ->
            resource(Size - 1, Capacity, SP, SC - 1)
    end.
