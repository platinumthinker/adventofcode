#!/usr/bin/env escript
%% -*- erlang -*-
%%! -smp enable -sname factorial -mnesia debug verbose

%%%----------------------------------------------------------------------------
%%% @author platinumthinker <platinumthinker@gmail.com>
%%% @doc
%%%
%%% @end
%%%----------------------------------------------------------------------------

-export([
    main/1
]).

main([Args]) ->
    {ok, Input} = file:read_file(Args),
    Opts = [global, trim_all],
    Lines = [ string:tokens(binary_to_list(L), "[]-") ||
              L <- binary:split(Input, <<"\n">>, Opts) ],
    io:format("~p ~n", [solve(Lines)]).

solve(Rooms) -> solve(Rooms, [[]], #{}).
solve( [], [[] | Acc], _) -> solve2(Acc);
solve( [ [ Id, Dict ] | Rooms ], [Aa | Acc], Fr) ->
    Dict1 = [ {A, maps:get(A, Fr, 0)} || A <- Dict ],
    Dict2 = hash(Fr),
    Acc1 = case Dict1 == Dict2 of
        true ->
            El = {list_to_integer(Id), string:join(lists:reverse(Aa), " ")},
            [ [] | [ El | Acc] ];
        false -> [ [] | Acc ]
    end,
    solve(Rooms, Acc1, #{});
solve( [ [ A | Room] | Rooms ], [Aa | Acc], Fr) ->
    NFr = lists:foldl(
      fun(Ch, FrAcc) ->
              FrAcc#{Ch => maps:get(Ch, FrAcc, 0) + 1}
      end, Fr, A),
    solve( [ Room | Rooms ], [[A | Aa] | Acc], NFr).

hash(Map) ->
    Map1 = lists:sort(
            fun({Key1, N}, {Key2, N}) -> Key1 < Key2;
               ({_,   N1}, {_,   N2}) -> N1 > N2
            end, maps:to_list(Map)),
    lists:reverse(hash(Map1, [], 0)).

hash(_, Acc, 5) -> Acc;
hash([{A, B} | T], Acc, L) -> hash(T, [{A, B} | Acc], L + 1).

solve2(Acc) ->
    [ shift(Str, Key) || {Key, Str} <- Acc].

shift(A, Key) -> {Key, shift(A, Key, [])}.
shift([], _, Acc) -> lists:reverse(Acc);
shift([32 | T], Key, Acc) ->
    shift(T, Key, [ 32 | Acc]);
shift([A | T], Key, Acc) ->
    shift(T, Key, [ ((A - $a + Key) rem 26) + $a | Acc]).
