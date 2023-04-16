%%% Names: Qi-Rui Hong
%%% Pledge: I pledge my honor that I have abided by the Stevens Honor System.

-module(dc).
-compile(nowarn_export_all).
-compile(export_all).

dryCleanerLoop(Clean, Dirty) ->
    %% Clean, Dirty are counters
    receive
        {dropOffOverall} ->
            io:format(
                "One employee dropped off | Clean: ~w , Dirty: ~w\n",
                [Clean, Dirty + 1]
            ),
            dryCleanerLoop(Clean, Dirty + 1);
        {From, dryCleanItem} when Dirty > 0 ->
            From ! {okToClean},
            io:format(
                "Machine ~w done cleaning | Clean: ~w , Dirty: ~w\n",
                [From, Clean + 1, Dirty - 1]
            ),
            dryCleanerLoop(Clean + 1, Dirty - 1);
        {From, pickUpOverall} when Clean > 0 ->
            From ! {okToPick},
            io:format(
                "Employee ~w picked up | Clean: ~w , Dirty: ~w\n",
                [From, Clean - 1, Dirty]
            ),
            dryCleanerLoop(Clean - 1, Dirty)
    end.

employee(DC) ->
    % drop off overall, then pick up a clean one (if none % is available , wait), and end
    DC ! {dropOffOverall},
    DC ! {self(), pickUpOverall},
    receive
        {okToPick} -> ok
    end.

dryCleanMachine(DC) ->
    % dry clean item (if none are available, wait),
    % then sleep for a while (timer:sleep(1000)) and repeat
    DC ! {self(), dryCleanItem},
    receive
        {okToClean} ->
            timer:sleep(1000),
            dryCleanMachine(DC)
    end.

start(E, M) ->
    % E= no. of employees, M= no. of machines
    DC = spawn(?MODULE, dryCleanerLoop, [0, 0]),
    [spawn(?MODULE, employee, [DC]) || _ <- lists:seq(1, E)],
    [spawn(?MODULE, dryCleanMachine, [DC]) || _ <- lists:seq(1, M)].
