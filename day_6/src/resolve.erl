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

input_int(Str) ->
    [A, B] = string:tokens(Str, ","),
    { element(1, string:to_integer(A)), element(1, string:to_integer(B)) }.

input() ->
    {ok, Binary} = file:read_file("input.txt"),
    Data = binary:part(Binary, 0, byte_size(Binary) - 1),
    lists:map(
      fun(["turn", "off", First, _, Second]) ->
              {fun off/2, input_int(First), input_int(Second)};
         (["turn", "on",  First, _, Second]) ->
              {fun on/2, input_int(First), input_int(Second)};
         (["toggle", First, _, Second]) ->
              {fun toggle/2, input_int(First), input_int(Second)}
      end, [ string:tokens(erlang:binary_to_list(Bin), " ") ||
                 Bin <- binary:split(Data, [<<"\n">>], [global]) ]).

resolve(Input) ->
    M = lists:foldl(fun step/2, #{}, Input),
    {ok, Out} = file:open("output.txt", [write]),
    maps:fold(
      fun({A, B}, C, _) ->
        io:fwrite(Out, "~p ~p ~p~n", [A, B, C])
      end, ok, M),
    file:close(Out),
    count(M).

on(Key, M) ->
    case maps:find(Key, M) of
        {ok, V} -> M#{Key => V + 1};
        error   -> M#{Key => 1}
    end.
off(Key, M) ->
    case maps:find(Key, M) of
        {ok, V} when V > 1 -> M#{Key => V - 1};
        _ -> M#{Key => 0}
    end.
toggle(Key, M) ->
    case maps:find(Key, M) of
        {ok, V} -> M#{Key => V + 2};
        error   -> M#{Key => 2}
    end.

count(M) ->
    maps:fold(fun(_, V, Acc) -> V + Acc end, 0, M).

step({_, {A,_}, _} = V, M) -> step(V, A, M).
step({Action, Key, Key}, _, M) -> Action(Key, M);
step({Action, {A, B1} = K1, {A, _} = K2}, A1, M) ->
    step({Action, {A1, B1 + 1}, K2}, Action(K1, M));
step({Action, {A1, B1} = K1, K2}, A, M) ->
    step({Action, {A1 + 1, B1}, K2}, A, Action(K1, M)).

-ifdef(TEST).

step_test() ->
    ?assertEqual(resolve([{fun on/2, {0, 0}, {2, 2}}]), 9),
    ?assertEqual(resolve([{fun on/2, {0, 0}, {999, 999}}]), 1000000),
    ?assertEqual(resolve([{fun toggle/2, {0, 0}, {999, 0}}]), 1000),
    ?assertEqual(resolve([
                          {fun on/2, {0, 0}, {999, 999}},
                          {fun off/2, {499, 499}, {500, 500}}
                          ]), 1000000 - 4).

-endif. %%TEST
