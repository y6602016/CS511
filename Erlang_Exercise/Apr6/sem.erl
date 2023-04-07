-module(sem).
-compile(nowarn_export_all).
-compile(export_all).

make_sem(N) ->
    spawn(?MODULE, sem_loop, [N]).

sem_loop(0) ->
    receive
        {release} ->
            sem_loop(1)
    end;
sem_loop(N) when N > 0 ->
    receive
        {acquire, From} ->
            From ! {ok},
            sem_loop(N - 1);
        {release} ->
            sem_loop(N + 1)
    end.

acquire(S) ->
    S ! {acquire, self()},
    receive
        {ok} -> ok
    end.

release(S) ->
    S ! {release}.
