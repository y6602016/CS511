-module(ex6).
-compile(export_all).

fibonacci(0) -> 0;
fibonacci(1) -> 1;
fibonacci(X) when X > 1 -> fibonacci(X - 1) + fibonacci(X - 2).

%%% stop condition: X = 0, from X to 0 means iterating X times
%%% Acc1 = accumulator for N - 1
%%% Acc2 = accumulator for N - 2
%%% Acc1/2 initialized as 0/1, becuz when X = 1, Acc1 should be 0(X = 0), and the result
%%% should be 1, so Acc2 should be 1. Then Acc1 = 1 and Acc2 = 1 for X = 2, which results to 2(X = 2).
fibonacciTR(X) -> fibonacciTRHelper(X, 0, 1).
fibonacciTRHelper(0, Acc1, _) -> Acc1;
%%% the current N - 1 is next one's N - 2, so pass Acc1 as Acc2
fibonacciTRHelper(X, Acc1, Acc2) -> fibonacciTRHelper(X - 1, Acc1 + Acc2, Acc1).
