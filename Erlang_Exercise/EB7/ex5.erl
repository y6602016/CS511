-module(ex5).
-compile(export_all).
-author("Mike").

mult(X, Y) -> X * Y.
double(X) -> X * 2.
distance({X1, Y1}, {X2, Y2}) -> math:sqrt(math:pow(X2 - X1, 2) + math:pow(Y2 - Y1, 2)).

my_and(X, Y) ->
    if
        X and Y -> true;
        true -> false
    end.

my_or(X, Y) ->
    if
        X or Y -> true;
        true -> false
    end.

my_not(X) ->
    if
        X -> false;
        true -> true
    end.
