-module(calc).
-compile(export_all).

env() ->
    #{"x" => 3, "y" => 7}.
e1() ->
    {add, {const, 3}, {divi, {var, "x"}, {const, 4}}}.
e2() ->
    {add, {const, 3}, {divi, {var, "x"}, {const, 0}}}.
e3() ->
    {add, {const, 3}, {divi, {var, "r"}, {const, 4}}}.
calc({const, V}, _) ->
    {val, V};
calc({var, K}, E) ->
    case maps:find(K, E) of
        {ok, V} -> {val, V};
        {error, _} -> throw(unbound_identifier_error)
    end;
calc({add, E1, E2}, E) ->
    {val, V1} = calc(E1, E),
    {val, V2} = calc(E2, E),
    {val, V1 + V2};
calc({sub, E1, E2}, E) ->
    {val, V1} = calc(E1, E),
    {val, V2} = calc(E2, E),
    {val, V1 - V2};
calc({mult, E1, E2}, E) ->
    {val, V1} = calc(E1, E),
    {val, V2} = calc(E2, E),
    {val, V1 * V2};
calc({divi, E1, E2}, E) ->
    {val, V1} = calc(E1, E),
    {val, V2} = calc(E2, E),
    case V1 div V2 of
        {error, _} -> throw(division_by_zero_error);
        V -> {val, V}
    end.
