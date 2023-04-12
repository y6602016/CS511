-module(ex2_2).
-compile(nowarn_export_all).
-compile(export_all).

start() ->
    S = spawn(?MODULE, server, []),
    [spawn(?MODULE, client, [S]) || _ <- lists:seq(1, 20)],
    S.

clientConcatenate(Servlet) ->
    Servlet ! {add, "h", self()},
    Servlet ! {add, "e", self()},
    Servlet ! {add, "l", self()},
    Servlet ! {add, "l", self()},
    Servlet ! {add, "o", self()},
    Servlet ! {done, self()},
    receive
        {Servlet, Str} -> io:format("Done: ~p~s~n", [self(), Str])
    end.

client(S) ->
    S ! {start, self()},
    receive
        {S, Servlet} -> clientConcatenate(Servlet)
    end.

%%% server needs to maintain the state of each client?
server() ->
    receive
        {start, From} ->
            S = spawn(?MODULE, servlet, [""]),
            From ! {self(), S},
            server()
    end.

servlet(S) ->
    receive
        {add, String, _From} ->
            servlet(S ++ String);
        {done, From} ->
            From ! {self(), S}
    end.
