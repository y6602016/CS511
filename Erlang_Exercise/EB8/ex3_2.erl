-module(ex3_2).
-compile(export_all).

server(Counter, Continue) ->
    receive
        {From, counter} ->
            From ! {self(), Continue - Counter},
            server(Continue, Continue);
        {continue} ->
            server(Counter, Continue + 1)
    end.

client(S) ->
    S ! {self(), counter},
    receive
        {S, C} -> io:fwrite("~w~n", [C])
    end.

start() ->
    spawn(?MODULE, server, [0, 0]).
