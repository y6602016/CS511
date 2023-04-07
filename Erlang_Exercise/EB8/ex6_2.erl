-module(ex6_2).
-compile(export_all).

checkPrime(N) ->
    [V || V <- lists:seq(1, N), (N rem V) == 0].

prime(N) when N == 0; N == 1 -> false;
prime(N) when N > 1 ->
    checkPrime(N) == [1, N].

server() ->
    receive
        {From, N} ->
            From ! {self(), prime(N)},
            server()
    end.

start() ->
    spawn(?MODULE, server, []).
