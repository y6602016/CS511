-module(ex3_1).
-compile(export_all).

server(Counter, Continue) ->
    receive
        {counter} ->
            io:fwrite("~w~n", [Continue - Counter]),
            server(Continue, Continue);
        {continue} ->
            server(Counter, Continue + 1)
    end.

start() ->
    spawn(?MODULE, server, [0, 0]).
