-module(ex9).
-compile(export_all).

l1() -> [122, 2, 23, 53, 14, 84, 43].

map(_F, []) -> [];
map(F, [X | A]) -> [F(X) | map(F, A)].

filter(_F, []) ->
    [];
filter(F, [X | A]) ->
    case F(X) of
        true -> [X | filter(F, A)];
        false -> filter(F, A)
    end.

fold(_F, V, []) -> V;
fold(F, V, [X | A]) -> F(X, fold(F, V, A)).
