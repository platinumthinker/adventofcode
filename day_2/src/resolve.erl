-module(resolve).
-export([main/1]).
-define(OUT(F,A), io:format(F ++ "\n",A)).

main(_Args) ->
    Res = resolve(input(), 0),
    ?OUT("Out: ~p", [Res]).

input() ->
    {ok, Binary} = file:read_file("input.txt"),
    Data = binary:part(Binary, 0, byte_size(Binary) - 1),
    [ erlang:binary_to_integer(Int) ||
        Int <- binary:split(Data, [<<$x>>, <<"\n">>], [global]) ].

resolve([A, B, C|T], Area) ->
    resolve(T, Area + area([A, B, C]));
resolve(_, Area) -> Area.

area(L) -> A = lists:max(L), area(A, L -- [A]).
area(A, [B, C]) -> B * 2 + C * 2 + A * B * C.
