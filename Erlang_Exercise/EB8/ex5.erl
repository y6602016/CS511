-module(ex5).
-compile(export_all).

client(S, C) ->
    S ! {self(), register},
    receive
        {ok} -> client(C)
    end.

client(C) ->
    receive
        {tick} ->
            io:fwrite("~w goty tick, ~w round~n", [self(), C]),
            client(C + 1)
    end.

%%% how to handle "register" and "send tick"?
timer(N, P) ->
    receive
        {From, register} ->
            From ! {ok},
            timer(N, P ++ [From])
    after 0 ->
        timer:sleep(N),
        [Pid ! {tick} || Pid <- P],
        timer(N, P)
    end.

start(N) ->
    S = spawn(?MODULE, timer, [N, []]),
    [spawn(?MODULE, client, [S, 0]) || _ <- lists:seq(1, 10)],
    S.
