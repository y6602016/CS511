-module(ex8).
-compile(export_all).

start() ->
    S = spawn(?MODULE, server, []),
    [spawn(?MODULE, client, [S]) || _ <- lists:seq(1, 10)].

servlet(V, Ref) ->
    receive
        {Pid, Ref, Number} when V == Number ->
            Pid ! {self(), Ref, true};
        {Pid, Ref, Number} when V /= Number ->
            Pid ! {self(), Ref, false},
            servlet(V, Ref)
    end.

server() ->
    receive
        {From, Ref, start} ->
            V = rand:uniform(10),
            Servlet = spawn(?MODULE, servlet, [V, Ref]),
            From ! {self(), Servlet, Ref, ok},
            server()
    end.

clientLoop(Servlet, R, Guess) ->
    Servlet ! {self(), R, Guess},
    receive
        {Servlet, R, true} ->
            io:fwrite("~w guesses correct value: ~w~n", [self(), Guess]);
        {Servlet, R, false} ->
            io:fwrite("~w guesses ~w, but it's wrong~n", [self(), Guess]),
            clientLoop(Servlet, R, rand:uniform(100))
    end.

client(S) ->
    R = make_ref(),
    S ! {self(), R, start},
    receive
        {S, Servlet, R, ok} ->
            clientLoop(Servlet, R, rand:uniform(100))
    end.
