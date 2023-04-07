-module(fcs).
-compile(export_all).

fact(0) -> 1;
fact(N) -> N * fact(N - 1).

loop(Count) ->
    receive
        {get_count, From, Ref} ->
            From ! {result, Ref, Count},
            loop(Count);
        {factorial, From, Ref, N} ->
            Result = fact(N),
            From ! {result, Ref, Result},
            loop(Count + 1);
        stop ->
            ok
    end.

start() ->
    spawn(?MODULE, loop, [0]).

compute(Pid, N) ->
    Ref = make_ref(),
    Pid ! {factorial, self(), Ref, N},
    receive
        {result, Ref, Result} -> Result
    after 5000 -> timeout
    end.
