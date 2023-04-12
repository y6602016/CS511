-module(barr).
-compile(nowarn_export_all).
-compile(export_all).

make(N) ->
    spawn(?MODULE, coordinator, [N, N, []]).

reached(B) ->
    %%% self() here is the Pid of the clinet who calls
    B ! {reached, self()},
    receive
        {ok} -> ok
    end.

% coorpdinator(M, N, L).
% N is the size of the barrir
% M is the number of processes YET to arrive at the barrier
% L is a list of the PIDs of the processes that have already arrived at the barrier

coordinator(N, 0, L) ->
    %%% everyone reach to the barrier
    [Pid ! {ok} || Pid <- L],
    coordinator(N, N, []);
coordinator(N, M, L) when M > 0 ->
    receive
        {reached, From} ->
            coordinator(N, M - 1, [From | L])
    end.
