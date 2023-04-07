-module(ex6_1).
-compile(export_all).

checkPrime(N) ->
    [V || V <- lists:seq(1, N), (N rem V) == 0].

prime(N) when N == 0; N == 1 -> false;
prime(N) when N > 1 ->
    checkPrime(N) == [1, N].

server() ->
    receive
        {From, R, N} ->
            From ! {self(), R, prime(N)},
            server()
    end.

client(S) ->
    R = make_ref(),
    V = rand:uniform(100),
    S ! {self(), R, V},
    receive
        {S, R, true} ->
            io:fwrite("~w is a prime number~n", [V]);
        {S, R, false} ->
            io:fwrite("~w is not a prime number~n", [V])
    end.

start() ->
    S = spawn(?MODULE, server, []),
    [spawn(?MODULE, client, [S]) || _ <- lists:seq(1, 10)],
    S.
