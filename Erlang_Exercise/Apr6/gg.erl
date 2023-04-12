-module(gg).
-compile(nowarn_export_all).
-compile(export_all).

start() ->
    S = spawn(?MODULE, server_loop, []),
    [spawn(?MODULE, client, [S]) || _ <- lists:seq(1, 3)].

client(S) ->
    S ! {self(), start},
    receive
        {ok, Servlet} ->
            client_loop(Servlet, rand:uniform(10))
    end.

client_loop(Servlet, Guess) ->
    Servlet ! {Guess, self()},
    receive
        {true, T} ->
            io:fwrite("~w guesses correct ~w and tries ~w times~n", [self(), Guess, T]);
        {tryagain} ->
            io:fwrite("~w guesses ~w, but it's wrong~n", [self(), Guess]),
            client_loop(Servlet, rand:uniform(10))
    end.

server_loop() ->
    receive
        {From, start} ->
            Servlet = spawn(?MODULE, servlet, [rand:uniform(10), 1]),
            From ! {ok, Servlet},
            server_loop()
    end.

servlet(N, T) ->
    receive
        {Guess, From} when Guess == N ->
            From ! {true, T};
        {Guess, From} when Guess /= N ->
            From ! {tryagain},
            servlet(N, T + 1)
    end.
