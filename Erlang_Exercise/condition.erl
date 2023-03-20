-module(condition).
-export([start/0]).

start() ->
    A = 7,
    B = 6,
    if
        A > B ->
            io:fwrite("A is larger than B");
        A < B ->
            io:fwrite("A is less than B");
        true ->
            io:fwrite("A is eqault to B")
    end,

    case A of
        5 -> io:fwrite("The value of A is 5");
        6 -> io:fwrite("The value of A is 6");
        _ -> io:fwrite("The value of A is not 5 nor 6")
    end.
