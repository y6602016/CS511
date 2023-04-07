-module(ex2).
-compile(export_all).

start() ->
    S = spawn(?MODULE, server, [#{}]),
    [spawn(?MODULE, client, [S]) || _ <- lists:seq(1, 200)],
    S.

client(S) ->
    S ! {start, self()},
    S ! {add, "h", self()},
    S ! {add, "e", self()},
    S ! {add, "l", self()},
    S ! {add, "l", self()},
    S ! {add, "o", self()},
    S ! {done, self()},
    receive
        {S, Str} -> io:format("Done: ~p~s~n", [self(), Str])
    end.

%%% server needs to maintain the state of each client?
server(M) ->
    receive
        {start, From} ->
            server(maps:put(From, "", M));
        {add, S, From} ->
            OldS = maps:get(From, M),
            NewS = OldS ++ S,
            server(maps:update(From, NewS, M));
        {done, From} ->
            From ! {self(), maps:get(From, M)},
            server(M)
    end.
