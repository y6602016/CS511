-module(reverse).
-export([reverse/2, reverse/1, start/0]).

reverse(X) -> reverse(X, []).

reverse([], Temp) -> Temp;
reverse([A | B], Temp) -> reverse(B, [A | Temp]).

start() ->
    X = [1, 2, 3, 4],
    Y = reverse(X),
    io:fwrite("~w", [Y]).
