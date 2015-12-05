-module(resolve).
-export([main/1]).
-define(OUT(F,A), io:format(F ++ "\n",A)).

main(_Args) ->
    Res = resolve(input()),
    ?OUT("Out: ~p", [Res]).

input() ->
    {ok, Binary} = file:read_file("input.txt"),
    binary:part(Binary, 0, byte_size(Binary) - 1).

resolve(Input) ->
    step(Input, #{0 => {0, 0}, 1 => {0, 0}}, {1, #{ {0, 0} => 1 }}).

add(Key, {Count, Map}) when is_map(Map#{Key := 1}) ->
    {Count, Map#{Key => 1}};
add(Key, {Count, Map}) ->
    {Count + 1, Map#{Key => 1}}.

step(<<Dir, T/binary>>, Keys, Acc) ->
    Index = size(T) rem 2,
    #{ Index := Key } = Keys,
    NewKey = move(Dir, Key),
    step(T, Keys#{ Index => NewKey}, add(NewKey, Acc));
step(_, _, {Count, _}) -> Count.

move($^, {X, Y}) -> {X, Y + 1};
move($v, {X, Y}) -> {X, Y - 1};
move($>, {X, Y}) -> {X + 1, Y};
move($<, {X, Y}) -> {X - 1, Y}.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

resolve_test() ->
    ?assertEqual(resolve(<<"^v">>), 3),
    ?assertEqual(resolve(<<"^>v<">>), 3),
    ?assertEqual(resolve(<<"^v^v^v^v^v">>), 11).

-endif. %%TEST
