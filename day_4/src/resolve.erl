-module(resolve).
-export([main/1]).

-mode(compile).
-include_lib("eunit/include/eunit.hrl").

-define(OUT(F,A), io:format(F ++ "\n",A)).
-define(ZERRO, 6).

main(_Args) ->
    Res = resolve(input()),
    ?OUT("Out: ~p", [Res]).

input() ->
    <<"ckczppom">>.

resolve(Input) ->
    step(Input, 0, hash(Input, 0)).

step(_, Postfix, true) -> Postfix;
step(Input, Postfix, _) ->
    Inc = Postfix + 1,
    step(Input, Inc, hash(Input, Inc)).

hash(Bin, Inc) ->
    BinInc = integer_to_binary(Inc),
    Hash = binary:part(crypto:hash(md5, <<Bin/binary, BinInc/binary>>), 0, ?ZERRO),
    R = << <<Y>> || <<X:4>> <= Hash, Y <- integer_to_list(X, 16)>>,
    binary:match(R, binary:copy(<<"0">>, ?ZERRO), [{scope,{0, ?ZERRO}}]) == {0, ?ZERRO}.

-ifdef(TEST).

hash_test() ->
    ?assert(hash(<<"abcdef">>, 609043)),
    ?assert(hash(<<"pqrstuv">>, 1048970)).

resolve_test_() ->
    {timeout, 8000,
     [
      ?_assertEqual(resolve(<<"abcdef">>), 609043),
      ?_assertEqual(resolve(<<"pqrstuv">>), 1048970)
     ]
    }.

-endif. %%TEST
