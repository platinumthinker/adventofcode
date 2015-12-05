-module(resolve).
-export([main/1]).

-mode(compile).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-define(OUT(F,A), ?debugFmt(F ++ "\n", A)).
-else.
-define(OUT(F,A), io:format(F ++ "\n", A)).
-endif.

main(_Args) ->
    Res = resolve(input()),
    ?OUT("Out: ~p", [Res]).

input() ->
    {ok, Binary} = file:read_file("input.txt"),
    Data = binary:part(Binary, 0, byte_size(Binary) - 1),
    [ erlang:binary_to_list(Str) ||
        Str <- binary:split(Data, [<<"\n">>], [global]) ].

is_nice(String) ->
    ?OUT("~s => ~p ~p", [ String, rule1(String), rule2(String)] ),
    rule1(String) andalso rule2(String).

rule1([X, Y | Tail]) ->
    case rule1(Tail, [X, Y]) of
        true -> true;
        _ -> rule1([Y | Tail])
    end;
rule1(_) -> false.

rule1([_ | Tail] = String, Acc) ->
    case string:str(String, Acc) of
        0 -> rule1(Tail, Acc);
        _ -> true
    end;
rule1(_, _) -> false.

rule2([X, _, X | _Tail]) -> true;
rule2([_ | Tail]) -> rule2(Tail);
rule2(_) -> false.


resolve(Input) ->
    length(lists:filter(fun is_nice/1, Input)).

-ifdef(TEST).

rule1_test() ->
    ?assert(rule1("xyxy")),
    ?assert(rule1("aabcdefgaa")),
    ?assert(not rule1("aaa")).

rule2_test() ->
    ?assert(rule2("xyx")),
    ?assert(rule2("abcdefeghi")),
    ?assert(rule2("aaa")).

nice_test() ->
    ?assert(is_nice("qjhvhtzxzqqjkmpb")),
    ?assert(is_nice("xxyxx")).

naughty_test() ->
    ?assert(not is_nice("uurcxstgmygtbstg")),
    ?assert(not is_nice("ieodomkazucvgmuy")).

-endif. %%TEST
