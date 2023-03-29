-module(test).
-compile(export_all).
-author("Mike").

t1() ->
    {node, 33, [
        {node, 22, []},
        {node, 14, [
            {node, 66, []},
            {node, 13, [
                {node, 89, []}
            ]}
        ]},
        {node, 4, [
            {node, 47, []},
            {node, 31, []},
            {node, 58, []}
        ]}
    ]}.

map(_F, []) -> [];
map(F, [X | A]) -> [mapGTree(F, X)] ++ map(F, A).

mapGTree(F, {node, Number, []}) -> {node, F(Number), []};
mapGTree(F, {node, Number, X}) -> {node, F(Number), map(F, X)}.

fold(_F, A, []) -> A;
fold(F, A, [X | Y]) -> F(foldGTree(F, A, X), fold(F, A, Y)).

foldGTree(F, A, {node, Number, []}) -> F(A, Number);
foldGTree(F, A, {node, Number, X}) -> F(Number, fold(F, A, X)).
