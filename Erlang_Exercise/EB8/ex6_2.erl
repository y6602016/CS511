-module(ex6_2).
-compile(export_all).
-compile(nowarn_export_all).

prime(N) when N == 0; N == 1 -> {false};
prime(N) when N > 1 ->
    {[V || V <- lists:seq(1, N), (N rem V) == 0] == [1, N]}.

start() ->
    ex6_2_server:start(server, fun prime/1).

compute(N) ->
    ex6_2_server:request(server, N).
