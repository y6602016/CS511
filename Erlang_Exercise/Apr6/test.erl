-module(test).
-compile(nowarn_export_all).
-compile(export_all).

start() ->
    R = ["a", "b", "c"],
    T = "dd",
    io:format("~w\n", [lists:member(T, R)]).
