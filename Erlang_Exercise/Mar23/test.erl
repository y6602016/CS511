-module(test).
-compile(export_all).
-author("Mike").

ex(L) ->
    case L of
        [A] -> io:fwrite("one");
        [A | B] -> io:fwrite("more than one");
        [] -> io:fwrite('empty')
    end.
