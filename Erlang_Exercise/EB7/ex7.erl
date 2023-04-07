-module(ex7).
-compile(export_all).

%%% use shell:strings(false). to disable auto-converting integer to string
l1() -> [122, 1, 23, 53, 14, 84, 43].
l2() -> [2].

sum([]) -> 0;
sum([X | Y]) -> X + sum(Y).

maximum([]) -> error(empty_list);
maximum([X]) -> X;
maximum([X | Y]) -> max(X, maximum(Y)).

zip([], []) -> [];
zip([X | A], []) -> [{X, none} | zip(A, [])];
zip([], [Y | B]) -> [{Y, none} | zip([], B)];
zip([X | A], [Y | B]) -> [{X, Y} | zip(A, B)].

append([], Y) -> Y;
append([X | A], Y) -> [X | append(A, Y)].

reverse([]) -> [];
reverse([X | A]) -> reverse(A) ++ [X].

evenL([]) ->
    [];
evenL([X | A]) ->
    if
        (X rem 2) =:= 0 ->
            [X | evenL(A)];
        true ->
            evenL(A)
    end.

take(0, _) ->
    [];
take(N, []) ->
    [none | take(N - 1, [])];
take(N, [Y | B]) ->
    if
        N < 0 -> error(unvalid_N);
        true -> [Y | take(N - 1, B)]
    end.

drop(0, Y) ->
    io:fwrite("~w~n", [Y]),
    Y;
drop(_, []) ->
    [];
drop(N, [_ | B]) ->
    if
        N < 0 -> error(unvalid_N);
        true -> drop(N - 1, B)
    end.
