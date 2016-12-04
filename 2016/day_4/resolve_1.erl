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
    erlang:display(solve(Lines)).

solve(Rooms) -> solve(Rooms, 0, #{}).
solve( [], Sum, _) -> Sum;
solve( [ [ Id, Dict ] | Rooms ], Sum, Fr) ->
    Dict1 = [ {A, maps:get(A, Fr, 0)} || A <- Dict ],
    Dict2 = hash(Fr),
    Sum1 = case Dict1 == Dict2 of
        true  -> list_to_integer(Id) + Sum;
        false -> Sum
    end,
    solve(Rooms, Sum1, #{});
solve( [ [ A | Room] | Rooms ], Sum, Fr) ->
    NFr = lists:foldl(
      fun(Ch, FrAcc) ->
              FrAcc#{Ch => maps:get(Ch, FrAcc, 0) + 1}
      end, Fr, A),
    solve( [ Room | Rooms ], Sum, NFr).

hash(Map) ->
    Map1 = lists:sort(
            fun({Key1, N}, {Key2, N}) -> Key1 < Key2;
               ({_,   N1}, {_,   N2}) -> N1 > N2
            end, maps:to_list(Map)),
    lists:reverse(hash(Map1, [], 0)).

hash(_, Acc, 5) -> Acc;
hash([{A, B} | T], Acc, L) -> hash(T, [{A, B} | Acc], L + 1).
