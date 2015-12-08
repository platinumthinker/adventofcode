-module(resolve).
-export([main/1]).

-mode(compile).

main(_Args) ->
    erlang:display(lists:foldl(fun(A, B) -> B + without_esc(A) end, 0, input())).

input() ->
    {ok, Binary} = file:read_file("input.txt"),
    Data = binary:part(Binary, 0, byte_size(Binary) - 1),
    [ binary_to_list(Str) || Str <- binary:split(Data, [<<"\n">>], [global]) ].

without_esc(L)                        -> length(L) - without_esc(L, - 2).
without_esc([$\\, $\\ | T], C)        -> without_esc(T, C + 1);
without_esc([$\\, $" | T], C)         -> without_esc(T, C + 1);
without_esc([$\\, $x, _A, _B | T], C) -> without_esc(T, C + 1);
without_esc([$\\, _ | T], C)          -> without_esc(T, C + 1);
without_esc([_ | T], C)               -> without_esc(T, C + 1);
without_esc([], C)                    -> C.
