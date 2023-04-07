-module(ex10).
-compile(export_all).

t1() ->
    {node, 33, {node, 22, {empty}, {empty}},
        {node, 14, {node, 12, {empty}, {empty}}, {node, 54, {empty}, {empty}}}}.

sumTree(X) -> sumTreeTR(X, 0).
sumTreeTR({empty}, Acc) ->
    Acc;
sumTreeTR({node, Number, LSubtree, RSubtree}, Acc) ->
    sumTreeTR(RSubtree, sumTreeTR(LSubtree, Acc + Number)).

%%% map should return the same structure
mapTree(_F, {empty}) ->
    {empty};
mapTree(F, {node, Number, LSubtree, RSubtree}) ->
    {node, F(Number), mapTree(F, LSubtree), mapTree(F, RSubtree)}.

foldTree({_F, V}, {empty}) ->
    V;
foldTree({F, V}, {node, Number, LSubtree, RSubtree}) ->
    F(Number, foldTree({F, V}, LSubtree), foldTree({F, V}, RSubtree)).
%%% F(X, Y, Z) vs F(X, F(Y, Z))
%%% or F(Number, F(foldTree(F, V, LSubtree), foldTree(F, V, RSubtree))).
