-module(carWash).
-compile(nowarn_export_all).
-compile(export_all).

start() ->
    M0 = spawn(?MODULE, machine, []),
    M1 = spawn(?MODULE, machine, []),
    M2 = spawn(?MODULE, machine, []),
    register(control_center, spawn(?MODULE, controlCenterLoop, [1, 1, 1])),
    [spawn(?MODULE, car, [M0, M1, M2]) || _ <- lists:seq(1, 20)].

machine() ->
    receive
        {From, permToProcess} ->
            timer:sleep(rand:uniform(1000)),
            From ! {doneProcessing},
            machine()
    end.

car(M0, M1, M2) ->
    acquireStation(0),
    waitForMachine(M0),

    acquireStation(1),
    releaseStation(0),
    io:fwrite("Car ~p @ Station 0 Done ~n", [self()]),
    waitForMachine(M1),

    acquireStation(2),
    releaseStation(1),
    io:fwrite("Car ~p @ Station 1 Done ~n", [self()]),
    waitForMachine(M2),

    releaseStation(2),
    io:fwrite("Car ~p @ Station 2 Done ~n", [self()]).

waitForMachine(N) ->
    io:fwrite("Machine ~p starts processing ~n", [N]),
    N ! {self(), permToProcess},
    receive
        {doneProcessing} -> io:fwrite("Machine ~p Done ~n", [N])
    end.

acquireStation(N) ->
    io:fwrite("Car ~p @ Station ~p Waiting ~n", [self(), N]),
    whereis(control_center) ! {self(), acquire, N},
    receive
        {ok} -> io:fwrite("Car ~p @ Station ~p Acquired ~n", [self(), N])
    end.

releaseStation(N) ->
    whereis(control_center) ! {self(), release, N}.

%% used by acquireStation and releaseStation
%% S0 is 0 ( station 0 has been acquired ) or 1 ( station 0 is free )
%% S1 is 0 ( station 1 has been acquired ) or 1 ( station 1 is free )
%% S2 is 0 ( station 2 has been acquired ) or 1 ( station 2 is free )
%% understands two types of messages :
%% {From , acquire ,N} -- acquire station N
%% {From , release ,N} -- release station N
controlCenterLoop(S0, S1, S2) ->
    receive
        {From, acquire, 0} when S0 == 1 ->
            From ! {ok},
            controlCenterLoop(0, S1, S2);
        {From, acquire, 1} when S1 == 1 ->
            From ! {ok},
            controlCenterLoop(S0, 0, S2);
        {From, acquire, 2} when S2 == 1 ->
            From ! {ok},
            controlCenterLoop(S0, S1, 0);
        {_From, release, 0} ->
            controlCenterLoop(1, S1, S2);
        {_From, release, 1} ->
            controlCenterLoop(S0, 1, S2);
        {_From, release, 2} ->
            controlCenterLoop(S0, S1, 1)
    end.
