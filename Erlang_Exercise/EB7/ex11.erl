-module(ex11).
-compile(export_all).

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

t2() -> {node, 1, []}.

%%% use a helper function which iterates the subTree list and returns a list containing all mapped subTrees
map(_F, []) -> [];
map(F, [X | A]) -> [mapGTree(F, X)] ++ map(F, A).
%%% mapGTree should return the same tree structure
mapGTree(F, {node, Number, []}) ->
    {node, F(Number), []};
mapGTree(F, {node, Number, A}) ->
    {node, F(Number), map(F, A)}.

%%% use a helper function which iterates the subTree list and returns the folded value
fold(_F, A, []) -> A;
fold(F, A, [X | Y]) -> F(foldGTree(F, A, X), fold(F, A, Y)).
%%% foldGTree should return the folded value from F(current node's value, the folded value of all subTrees )
foldGTree(F, V, {node, Number, []}) -> F(V, Number);
foldGTree(F, V, {node, Number, L}) -> F(Number, fold(F, V, L)).
