-module(resolve).
-export([main/1]).

-mode(compile).

main(_Args) ->
    input(), B = value("a"), input(), put("b", B), erlang:display(value("a")).

input() ->
    {ok, Binary} = file:read_file("input.txt"),
    Data = binary:part(Binary, 0, byte_size(Binary) - 1),
    lists:foreach(
      fun(Expr) -> put(hd(lists:reverse(Expr)), lists:droplast(Expr)) end,
      [ string:tokens(erlang:binary_to_list(Str), "-> ") ||
        Str <- binary:split(Data, [<<"\n">>], [global]) ]).

value(A) ->
    V = case string:to_integer(A) of
        {error, _} ->
                case get(A) of
                    Val when is_integer(Val) -> Val;
                    I when is_list(I) -> parse(I)
                end;
        {Val, _} -> Val
    end,
    put(A, V),
    V.

parse([A]) -> value(A);
parse(["NOT", A]) -> bnot value(A);
parse([A, "AND", B]) -> value(A) band value(B);
parse([A, "OR",  B]) -> value(A) bor  value(B);
parse([A, "LSHIFT", B]) -> value(A) bsl value(B);
parse([A, "RSHIFT", B]) -> value(A) bsr value(B).
