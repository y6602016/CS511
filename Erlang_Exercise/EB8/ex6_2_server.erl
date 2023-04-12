-module(ex6_2_server).
-compile(export_all).
-compile(nowarn_export_all).

start(Name, F) ->
    Pid = spawn(?MODULE, loop, [F]),
    register(Name, Pid),
    Pid.

loop(F) ->
    receive
        {update, From, Ref, NewF} ->
            From ! {ok, Ref},
            loop(NewF);
        {request, From, Ref, Data} ->
            case catch (F(Data)) of
                {'EXIT', Reason} ->
                    From ! {exit, Ref, Reason},
                    loop(F);
                {R} ->
                    From ! {result, Ref, R},
                    loop(F)
            end;
        {stop} ->
            ok
    end.

request(Pid, Data) ->
    Ref = make_ref(),
    Pid ! {request, self(), Ref, Data},
    receive
        {result, Ref, R} ->
            R;
        {exit, Ref, Reason} ->
            exit(Reason)
    end.
