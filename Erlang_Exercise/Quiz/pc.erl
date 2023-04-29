-module(pc).
-compile(nowarn_export_all).
-compile(export_all).

consumer(Id, Buffer) ->
    timer:sleep(200),
    io:fwrite("Consumer ~p trying to consume~n", [Id]),
    Ref = make_ref(),
    Buffer ! {start_consume, self(), Ref},
    receive
        {ok_to_consume, Ref} ->
            io:fwrite("Consumer ~p consuming ~n", [Id]),
            Buffer ! {end_consume},
            io:fwrite("Consumer ~p stop consuming ~n", [Id]),
            consumer(Id, Buffer)
    end.

producer(Id, Buffer) ->
    timer:sleep(1000),
    io:fwrite("Producer ~p trying to produce~n", [Id]),
    Ref = make_ref(),
    Buffer ! {start_produce, self(), Ref},
    receive
        {ok_to_produce, Ref} ->
            io:fwrite("Producer ~p producing ~n", [Id]),
            Buffer ! {end_produce},
            io:fwrite("Producer ~p stop producing ~n", [Id]),
            producer(Id, Buffer)
    end.

loopPC(Cs, Ps, MaxBufferSize, OccupiedSlots) ->
    receive
        {start_produce, From, Ref} when (Ps + OccupiedSlots) < MaxBufferSize ->
            From ! {ok_to_produce, Ref},
            loopPC(Cs, Ps + 1, MaxBufferSize, OccupiedSlots);
        {end_produce} ->
            loopPC(Cs, Ps - 1, MaxBufferSize, OccupiedSlots + 1);
        {start_consume, From, Ref} when (OccupiedSlots - Cs) > 0 ->
            From ! {ok_to_consume, Ref},
            loopPC(Cs + 1, Ps, MaxBufferSize, OccupiedSlots);
        {end_consume} ->
            loopPC(Cs - 1, Ps, MaxBufferSize, OccupiedSlots - 1)
    end.

startPC() ->
    Buffer = spawn(fun() -> loopPC(0, 0, 10, 0) end),
    [spawn(fun() -> producer(Id, Buffer) end) || Id <- lists:seq(1, 10)],
    [spawn(fun() -> consumer(Id, Buffer) end) || Id <- lists:seq(1, 10)].
