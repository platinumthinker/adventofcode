-module(resolve).
-export([main/1]).

main(_Args) ->
    M = lists:foldl(fun step/2, #{}, input()),
    {ok, Out} = file:open("output.txt", [write]),
    maps:fold(
      fun({A, B}, C, _) ->
        io:fwrite(Out, "~p ~p ~p~n", [A, B, C])
      end, ok, M),
    file:close(Out),
    erlang:display( maps:fold(fun(_, V, Acc) -> V + Acc end, 0, M) ).

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

on(Key, M)     -> M#{Key => maps:get(Key, M, 0) + 1}.
off(Key, M)    -> M#{Key => max(maps:get(Key, M, 0) - 1, 0)}.
toggle(Key, M) -> M#{Key => maps:get(Key, M, 0) + 2}.

step({_, {A,_}, _} = V, M) -> step(V, A, M).
step({Action, Key, Key}, _, M) -> Action(Key, M);
step({Action, {A, B1} = K1, {A, _} = K2}, A1, M) ->
    step({Action, {A1, B1 + 1}, K2}, Action(K1, M));
step({Action, {A1, B1} = K1, K2}, A, M) ->
    step({Action, {A1 + 1, B1}, K2}, A, Action(K1, M)).
