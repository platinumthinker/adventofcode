-module(resolve).
-export([main/1]).

-mode(compile).

main(_Args) ->
    erlang:display(lists:foldl(fun(A, B) -> B + with_esc(A) end, 0, input())).

input() ->
    {ok, Binary} = file:read_file("input.txt"),
    Data = binary:part(Binary, 0, byte_size(Binary) - 1),
    [ binary_to_list(Str) || Str <- binary:split(Data, [<<"\n">>], [global]) ].

with_esc(L)            -> with_esc(L, 2) - length(L).
with_esc([$"  | T], C) -> with_esc(T, C + 2);
with_esc([$\\ | T], C) -> with_esc(T, C + 2);
with_esc([_ | T], C)   -> with_esc(T, C + 1);
with_esc([], C)        -> C.
