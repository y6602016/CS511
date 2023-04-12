-module(pc).
-compile(nowarn_export_all).
-compile(export_all).

start(Cap, P, C) ->
    RS = spawn(?MODULE, resource, [0, Cap, 0, 0]),
    [spawn(?MODULE, producer, [RS]) || _ <- lists:seq(1, P)],
    [spawn(?MODULE, consumer, [RS]) || _ <- lists:seq(1, C)].

%% client code
producer(RS) ->
    startProduce(RS),
    timer:sleep(rand:uniform(100)),
    stopProduce(RS).

consumer(RS) ->
    startConsume(RS),
    timer:sleep(rand:uniform(100)),
    stopConsume(RS).

%% server code
startProduce(RS) ->
    RS ! {startProduce, self()},
    receive
        {ok} -> ok
    end.

stopProduce(RS) ->
    RS ! {stopProduce, self()}.

startConsume(RS) ->
    RS ! {startConsume, self()},
    receive
        {ok} -> ok
    end.

stopConsume(RS) ->
    RS ! {stopConsume, self()}.

resource(Size, Capacity, SP, SC) ->
    receive
        {startProduce, From} when Size + SP < Capacity ->
            io:fwrite("~w is producing ~w ~w ~w ~w ~n", [From, Size, Capacity, SP + 1, SC]),
            From ! {ok},
            resource(Size, Capacity, SP + 1, SC);
        {stopProduce, From} ->
            io:fwrite("~w stops producing ~w ~w ~w ~w ~n", [From, Size + 1, Capacity, SP - 1, SC]),
            resource(Size + 1, Capacity, SP - 1, SC);
        {startConsume, From} when Size - SC > 0 ->
            io:fwrite("~w is consuming ~w ~w ~w ~w ~n", [From, Size, Capacity, SP, SC + 1]),
            From ! {ok},
            resource(Size, Capacity, SP, SC + 1);
        {stopConsume, From} ->
            io:fwrite("~w stops consuming ~w ~w ~w ~w ~n", [From, Size - 1, Capacity, SP, SC - 1]),
            resource(Size - 1, Capacity, SP, SC - 1)
    end.
