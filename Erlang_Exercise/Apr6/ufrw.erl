-module(frw).
-compile(nowarn_export_all).
-compile(export_all).

loop(R, W) ->
    receive
        {start_read, From} when W == 0 ->
            From ! {ok},
            loop(R + 1, W);
        {end_read} ->
            loop(R - 1, W);
        {start_write, From} when (W == 0) and (R == 0) ->
            From ! {ok},
            loop(R, W + 1);
        {end_write} ->
            loop(R, W - 1)
    end.
