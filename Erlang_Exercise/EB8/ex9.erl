-module(ex9).
-compile(export_all).
-compile(nowarn_export_all).

server(Time, PidMap) ->
    timer:sleep(Time),
    Nodes = maps:keys(PidMap),
    [Pid ! {tick, maps:get(Pid, PidMap)} || Pid <- Nodes],
    server(Time, PidMap).

n(Token) ->
    receive
        {tick, Neighbors} ->
            io:fwrite("~w receives tick and sends to all neighbors~n", [self()]),
            [Pid ! {self(), Token} || Pid <- Neighbors],
            n(Token);
        {From, CopyToken} ->
            io:fwrite("~w receives copy token ~w from ~w~n", [self(), CopyToken, From]),
            n(Token)
    end.

start(T) ->
    A = spawn(?MODULE, n, [rand:uniform(100)]),
    B = spawn(?MODULE, n, [rand:uniform(100)]),
    C = spawn(?MODULE, n, [rand:uniform(100)]),
    PidMap = #{A => [B, C], B => [A, C], C => [A, B]},
    spawn(?MODULE, server, [T, PidMap]).
