-module(cl).
-compile(nowarn_export_all).
-compile(export_all).

start() ->
    S = sem:make_sem(0),
    spawn(?MODULE, client1, [S]),
    spawn(?MODULE, client2, [S]),
    ok.

client1(S) ->
    sem:acquire(S),
    io:format("a~n"),
    io:format("b~n").

client2(S) ->
    io:format("c~n"),
    io:format("d~n"),
    sem:release(S).
