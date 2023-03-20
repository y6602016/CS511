-module(whileLoop).
-export([while/1, start/0]).

while([]) ->
    ok;
while([A | B]) ->
    io:fwrite("~w~n", [A]),
    while(B).

start() ->
    X = [1, 2, 3, 4],
    while(X).
