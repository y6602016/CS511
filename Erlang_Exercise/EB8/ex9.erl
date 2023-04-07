-module(ex9).
-compile(export_all).

server(Time, PidMap) ->
    timer:sleep(Time),
    Nodes = maps:keys(PidMap),
    [Pid ! {tick, maps:get(Pid, PidMap)} || Pid <- Nodes],
    server(Time, PidMap).

n() ->
    receive
        {tick, Neighbors} ->
            io:fwrite("~w receives tick and sends to all neighbors~n", [self()]),
            [Pid ! {self(), copyTick} || Pid <- Neighbors],
            n();
        {From, copyTick} ->
            io:fwrite("~w receives copy tick from ~w~n", [self(), From]),
            n()
    end.

start(T) ->
    A = spawn(?MODULE, n, []),
    B = spawn(?MODULE, n, []),
    C = spawn(?MODULE, n, []),
    PidMap = #{A => [B, C], B => [A, C], C => [A, B]},
    spawn(?MODULE, server, [T, PidMap]).
