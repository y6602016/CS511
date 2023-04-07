-module(barrcl).
-compile(nowarn_export_all).
-compile(export_all).

start() ->
    B = barr:make(3),
    spawn(?MODULE, client1, [B]),
    spawn(?MODULE, client2, [B]),
    spawn(?MODULE, client3, [B]),
    ok.

client1(B) ->
    io:format("a~n"),
    barr:reached(B),
    io:format("1~n").

client2(B) ->
    io:format("b~n"),
    barr:reached(B),
    io:format("2~n").

client3(B) ->
    io:format("c~n"),
    barr:reached(B),
    io:format("3~n").
