-module(dc).
-compile(export_all).

dryCleaner(Clean, Dirty) ->
    receive
        {dropOffOverall} ->
            dryCleaner(Clean, Dirty + 1);
        {From, dryCleanItem} when Dirty > 0 ->
            io:format(
                "Machine ~w done cleaning | Clean: ~w , Dirty: ~w\n",
                [From, Clean + 1, Dirty - 1]
            ),
            From ! {ok},
            dryCleaner(Clean + 1, Dirty - 1);
        {From, pickUpOverall} when Clean > 0 ->
            io:format(
                "Employee ~w picked up | Clean: ~w , Dirty: ~w\n",
                [From, Clean - 1, Dirty]
            ),
            From ! {ok},
            dryCleaner(Clean - 1, Dirty)
    end.

employee(DC) ->
    DC ! {dropOffOverall},
    DC ! {self(), pickUpOverall},
    receive
        {ok} -> ok
    end.

dryCleanMachine(DC) ->
    DC ! {self(), dryCleanItem},
    receive
        {ok} ->
            timer:sleep(1000),
            dryCleanMachine(DC)
    end.

start(E, M) ->
    DC = spawn(?MODULE, dryCleaner, [0, 0]),
    [spawn(?MODULE, employee, [DC]) || _ <- lists:seq(1, E)],
    [spawn(?MODULE, dryCleanMachine, [DC]) || _ <- lists:seq(1, M)].
