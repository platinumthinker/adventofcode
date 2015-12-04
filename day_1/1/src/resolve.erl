-module(resolve).

-export([main/1]).

-define(OUT(Format, Args), io:format(Format ++ "\n", Args)).
-define(OUT(Format), ?OUT(Format, [])).

main(Args) ->
    ?OUT("Start with ~p", [Args]),
    res().

res() ->
    ?OUT("Hi!"),
    ok.
