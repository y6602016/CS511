%%% Stub for Quiz 6
%%% Names: Qi-Rui Hong
%%% Pledge: I pledge my honor that I have abided by the Stevens Honor System.

-module(calc).
-compile(nowarn_export_all).
-compile(export_all).

%% Sample environment
env() -> #{"x" => 15, "y" => 7}.

%% Sample calculator expression
e1() ->
    {mult, {const, 20}, {divi, {var, "x"}, {const, 3}}}.

%% Sample calculator expression
e2() ->
    {add, {const, 3}, {divi, {var, "x"}, {const, 0}}}.

%% Sample calculator expression
e3() ->
    {add, {const, 3}, {divi, {var, "r"}, {const, 4}}}.

eval({const, N}, _E) ->
    {val, N};
eval({var, Id}, E) ->
    case maps:find(Id, E) of
        {ok, V} -> {val, V};
        error -> throw(unbound_identifier_error)
    end;
eval({add, E1, E2}, E) ->
    {val, V1} = eval(E1, E),
    {val, V2} = eval(E2, E),
    {val, V1 + V2};
eval({sub, E1, E2}, E) ->
    {val, V1} = eval(E1, E),
    {val, V2} = eval(E2, E),
    {val, V1 - V2};
eval({mult, E1, E2}, E) ->
    {val, V1} = eval(E1, E),
    {val, V2} = eval(E2, E),
    {val, V1 * V2};
eval({divi, E1, E2}, E) ->
    {val, V1} = eval(E1, E),
    {val, V2} = eval(E2, E),
    case V2 of
        0 -> throw(division_by_zero_error);
        _Else -> {val, V1 div V2}
    end.
