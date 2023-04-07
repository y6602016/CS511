-module(ex2_2).
-compile(export_all).

start() ->
    S = spawn(?MODULE, server, []),
    [spawn(?MODULE, client, [S]) || _ <- lists:seq(1, 20)],
    S.

client(S) ->
    S ! {start, self()},
    receive
        {S, Servlet} -> ok
    end,
    Servlet ! {add, "h", self()},
    Servlet ! {add, "e", self()},
    Servlet ! {add, "l", self()},
    Servlet ! {add, "l", self()},
    Servlet ! {add, "o", self()},
    Servlet ! {done, self()},
    receive
        {Servlet, Str} -> io:format("Done: ~p~s~n", [self(), Str])
    end.

%%% server needs to maintain the state of each client?
server() ->
    receive
        {start, From} ->
            S = spawn(?MODULE, servlet, ["", From]),
            From ! {self(), S},
            server()
    end.

servlet(S, From) ->
    receive
        {add, String, From} ->
            servlet(S ++ String, From);
        {done, From} ->
            From ! {self(), S}
    end.
