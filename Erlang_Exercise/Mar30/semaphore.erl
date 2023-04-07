-module(semaphore).
-compile(export_all).

make_semaphore(Permits) ->
    spawn(?MODULE, semaphore, [Permits]).

%%% only receive release
semaphore(0) ->
    receive
        {From, Ref, release} ->
            From ! {self(), Ref, ok},
            semaphore(1)
    end;
semaphore(P) when P > 0 ->
    receive
        {From, Ref, release} ->
            From ! {self(), Ref, ok},
            semaphore(P + 1);
        {From, Ref, acquire} ->
            From ! {self(), Ref, ok},
            semaphore(P - 1)
    end.

release(S) ->
    R = make_ref(),
    S ! {self(), R, release},
    receive
        {S, R, ok} -> done
    end.

p1(S) ->
    io:fwrite("a~n"),
    release(S).

p2(S) ->
    R = make_ref(),
    %%% if ther server receive this first and permits = 0,
    %%% this message would be blocked and wait for being pattern match
    %%% the only chance to be consumed is sending a release to the server then
    %%% call semaphore(1) and consume acquire message
    S ! {self(), R, acquire},
    receive
        {S, R, ok} -> io:fwrite("b~n")
    end.

start() ->
    %%% activate the semaphore server with 0 permit
    S = make_semaphore(0),
    spawn(?MODULE, p1, [S]),
    spawn(?MODULE, p2, [S]).
