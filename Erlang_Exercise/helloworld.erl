% hello world program
-module(helloworld).
% import function used to import the io module
-import(io, [fwrite/2]).
% export function used to ensure the start function can be accessed.
-export([start/0]).

start() ->
    X = 40,
    Y = 50,
    fwrite("~w~n", [X]),
    fwrite("~w", [Y]).
