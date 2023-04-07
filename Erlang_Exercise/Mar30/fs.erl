-module(fs).
-compile(export_all).

%%% R = make_ref().
%%% R2 = make_ref().
%%% S!{self(), R, 10}.
%%% S!{self(), R2, 11}.

% server_loop() ->
%     receive
%         {From, Ref, N} ->
%             From ! {result, Ref, fact(N)},
%             server_loop();
%         stop ->
%             ok
%     end.

fact(0) ->
    1;
fact(N) when N > 0 ->
    N * fact(N - 1).

server_loop(C) ->
    receive
        {From, Ref, read} ->
            From ! {result, Ref, C},
            server_loop(C);
        {From, Ref, N} ->
            From ! {result, Ref, fact(N)},
            server_loop(C + 1);
        stop ->
            ok
    end.

start() ->
    spawn(?MODULE, server_loop, [0]).
