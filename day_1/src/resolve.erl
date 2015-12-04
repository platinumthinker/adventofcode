-module(resolve).
-export([main/1]).
-define(OUT(F,A), io:format(F ++ "\n",A)).

main(_Args) ->
    Res = lists:foldl(
      fun($(,  Acc) -> Acc - 1;
         ($),  Acc) -> Acc + 1;
         ($\n, Acc) -> Acc;
         (Var,  Acc) -> ?OUT("Unexpected: |~p|, Acc ~p", [Var, Acc]), Acc
      end, 0, input()),
    ?OUT("Out: ~p", [Res]).

input() ->
    {ok, Data} = file:read_file("input.txt"),
    binary_to_list(Data).
