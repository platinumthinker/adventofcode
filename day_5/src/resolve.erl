-module(resolve).
-export([main/1]).

-mode(compile).

-define(OUT(F,A), io:format(F ++ "\n",A)).

main(_Args) ->
    Res = resolve(input()),
    ?OUT("Out: ~p", [Res]).

input() ->
    {ok, Binary} = file:read_file("input.txt"),
    Data = binary:part(Binary, 0, byte_size(Binary) - 1),
    [ erlang:binary_to_list(Str) ||
        Str <- binary:split(Data, [<<"\n">>], [global]) ].

is_nice(String) ->
    ?OUT("~s => ~p ~p ~p", [ String, rule1(String), rule2(String), rule3(String)] ),
    rule3(String) andalso ( rule1(String) andalso rule2(String) ).

rule1(String) ->
    case re:run(String, "[aeiou]", [global]) of
        {match, Capture} when length(Capture) > 2 -> true;
        _ -> false
    end.

rule2([X, X | _Tail]) -> true;
rule2([_ | Tail]) -> rule2(Tail);
rule2(_) -> false.

rule3([$a, $b | _Tail]) -> false;
rule3([$c, $d | _Tail]) -> false;
rule3([$p, $q | _Tail]) -> false;
rule3([$x, $y | _Tail]) -> false;
rule3([_ | Tail]) -> rule3(Tail);
rule3(_) -> true.

resolve(Input) ->
    length(lists:filter(fun is_nice/1, Input)).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

nice_test() ->
    ?assert(is_nice("ugknbfddgicrmopn")),
    ?assert(is_nice("aaa")).

naughty_test() ->
    ?assert(not is_nice("jchzalrnumimnmhp")),
    ?assert(not is_nice("haegwjzuvuyypxyu")),
    ?assert(not is_nice("dvszwmarrgswjxmb")).

-endif. %%TEST
