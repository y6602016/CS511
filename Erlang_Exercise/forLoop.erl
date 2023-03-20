-module(forLoop).
-export([for/1, start/0]).

for(0) ->
    ok;
for(N) when N > 0 ->
    io:fwrite("~w~n", [N]),
    for(N - 1).

start() ->
    for(5).
