-module(test).
-compile(export_all).
-compile(nowarn_export_all).

start(T) ->
    A = spawn(?MODULE, n, [rand:uniform(100)]),
    B = spawn(?MODULE, n, [rand:uniform(100)]),
    C = spawn(?MODULE, n, [rand:uniform(100)]),
    PidMap = #{A => [B, C], B => [A, C], C => [A, B]},
    spawn(?MODULE, server, [T, PidMap]).

n(Token) ->
    receive
        {tick, L} ->
            [Pid ! {self(), Token} || Pid <- L],
            n(Token);
        {_From, _CopyToken} ->
            n(Token)
    end.

server(T, Map) ->
    timer:sleep(T),
    Nodes = maps:keys(Map),
    [Pid ! {tick, maps:get(Pid, Map)} || Pid <- Nodes],
    server(T, Map).
