-module(ex4).
-compile(export_all).

client(C) ->
    receive
        {tick} ->
            io:fwrite("~w goty tick, ~w round~n", [self(), C]),
            client(C + 1)
    end.

timer(N, P) ->
    timer:sleep(N),
    [Pid ! {tick} || Pid <- P],
    timer(N, P).

start(N) ->
    P = [spawn(?MODULE, client, [1]) || _ <- lists:seq(1, 10)],
    spawn(?MODULE, timer, [N, P]).
