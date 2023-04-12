-module(frw).
-compile(nowarn_export_all).
-compile(export_all).

start(R, W) ->
    S = spawn(?MODULE, loop, []),
    [spawn(?MODULE, reader, [S]) || _ <- lists:seq(1, R)],
    [spawn(?MODULE, writer, [S]) || _ <- lists:seq(1, W)],
    ok.

reader(S) ->
    R = make_ref(),
    S ! {start_read, self(), R},
    receive
        {ok_to_read, R} ->
            timer:sleep(1000),
            S ! {end_read, self()}
    end.

writer(S) ->
    R = make_ref(),
    S ! {start_write, self(), R},
    receive
        {ok_to_write, R} ->
            timer:sleep(2000),
            S ! {end_write}
    end.

loop() ->
    receive
        {start_read, From, Ref} ->
            io:fwrite("~w starts reading ~w~n", [From, 1]),
            From ! {ok_to_read, Ref},
            loop_read(1),
            loop();
        {start_write, From, Ref} ->
            io:fwrite("~w starts writing ~w~n", [From, 0]),
            From ! {ok_to_write, Ref},
            receive
                {end_write} ->
                    io:fwrite("~w ends writing ~w~n", [From, 0]),
                    loop()
            end
    end.

loop_read(0) ->
    ok;
loop_read(R) ->
    receive
        {start_read, From, Ref} ->
            io:fwrite("~w starts reading ~w~n", [From, R + 1]),
            From ! {ok_to_read, Ref},
            loop_read(R + 1);
        {end_read, From} ->
            io:fwrite("~w ends reading ~w~n", [From, R - 1]),
            loop_read(R - 1);
        {start_write, From, Ref} ->
            io:fwrite("~w wants writing ~w~n", [From, 0]),
            [
                receive
                    {end_read, FromR} ->
                        io:fwrite("~w ends reading ~w~n", [FromR, R - V]),
                        ok
                end
             || V <- lists:seq(1, R)
            ],
            From ! {ok_to_write, Ref},
            io:fwrite("~w starts writing ~w~n", [From, 0]),
            receive
                {end_write} ->
                    io:fwrite("~w ends writing ~w~n", [From, 0]),
                    ok
            end
    end.
