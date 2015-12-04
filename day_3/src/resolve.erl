-module(resolve).
-export([main/1]).
-define(OUT(F,A), io:format(F ++ "\n",A)).

main(_Args) ->
    Res = resolve(input()),
    ?OUT("Out: ~p", [Res]).

input() ->
    {ok, Binary} = file:read_file("input.txt"),
    binary:part(Binary, 0, byte_size(Binary) - 1).

resolve(Input) -> add(Input, {0, 0}, {0, #{}}).

add(Path, Key, {Count, Map}) when is_map(Map#{Key := 1}) ->
    move(Path, Key, {Count, Map#{Key => 1}});
add(Path, Key, {Count, Map}) ->
    move(Path, Key, {Count + 1, Map#{Key => 1}}).

move(<<$^, T/binary>>, {X, Y}, Acc) -> add(T, {X, Y + 1}, Acc);
move(<<$v, T/binary>>, {X, Y}, Acc) -> add(T, {X, Y - 1}, Acc);
move(<<$>, T/binary>>, {X, Y}, Acc) -> add(T, {X + 1, Y}, Acc);
move(<<$<, T/binary>>, {X, Y}, Acc) -> add(T, {X - 1, Y}, Acc);
move(_, _, {Count, _}) -> Count.
