-module(resolve).
-export([main/1]).
-define(OUT(F,A), io:format(F ++ "\n",A)).

main(_Args) ->
    Res = resolve(input(), {0, 0}),
    ?OUT("Out: ~p", [Res]).

input() ->
    {ok, Data} = file:read_file("input.txt"), Data.

resolve(_, {X, -1}) -> X;
resolve(<<$), T/binary>>, {X, Y}) -> resolve(T, {X + 1, Y - 1});
resolve(<<$(, T/binary>>, {X, Y}) -> resolve(T, {X + 1, Y + 1});
resolve(<<"\n">>, {X, _}) -> X.
