-module(test).
-compile(nowarn_export_all).
-compile(export_all).

server(T, M) ->
    timer:sleep(T),
    Nodes = maps:keys(M),
    [Pid ! {tick, maps:get(Pid, M)} || Pid <- Nodes],
    server(T, M).

n(Token) ->
    receive
        {tick, N} ->
            [P ! {self(), Token} || P <- N],
            n(Token);
        {From, T} ->
            n(Token)
    end.
