-module(test).
-compile(nowarn_export_all).
-compile(export_all).

start(E, M) ->
    % E= no. of employees, M= no. of machines
    DC = spawn(?MODULE, dryCleanerLoop, [0, 0]),
    [spawn(?MODULE, employee, [DC]) || _ <- lists:seq(1, E)],
    [spawn(?MODULE, dryCleanMachine, [DC]) || _ <- lists:seq(1, M)].

dryCleanerLoop(Clean, Dirty) ->
    receive
        {dropOffOverall} ->
            dryCleanerLoop(Clean, Dirty + 1);
        {From, dryCleanItem} when Dirty > 0 ->
            From ! {ok},
            dryCleanerLoop(Clean + 1, Dirty - 1);
        {From, pickUpOverall} when Clean > 0 ->
            From ! {ok},
            dryCleanerLoop(Clean - 1, Dirty)
    end.

dryCleanMachine(DC) ->
    DC ! {self(), dryCleanItem},
    receive
        {ok} ->
            timer:sleep(1000),
            dryCleanMachine(DC)
    end.

employee(DC) ->
    DC ! {dropOffOverall},
    DC ! {self(), pickUpOverall},
    receive
        {ok} -> ok
    end.
