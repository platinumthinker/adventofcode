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
    Lines = [ binary_to_list(L) || L <- binary:split(Input, <<"\n">>, Opts) ],
    Res = most_frequent(Lines),
    erlang:display(Res).

most_frequent(Lines) -> most_frequent(Lines, length(hd(Lines)), #{}).

most_frequent([], L, M) ->
    S = lists:sort(
      fun({{_, Pos1}, N1}, {{_, Pos1}, N2}) -> N1 > N2;
         ({{_, Pos1},  _}, {{_, Pos2},  _}) -> Pos1 < Pos2
      end, maps:to_list(M)),
    {_, Res} = lists:foldl(
      fun({{_,  _},   _}, {N, Acc}) when  N == L -> {N, Acc};
         ({{_,  Pos}, _}, {N, Acc}) when Pos < N -> {N, Acc};
         ({{Ch,   _}, _}, {N, Acc})              -> {N + 1, [Ch | Acc]};
         (A, B) -> io:format("aa ~p ~p~n", [A, B]), B
      end, {0, ""}, S),
    lists:reverse(Res);
most_frequent([Line | Lines], L, M) ->
    {_, NewM} = lists:foldl(
      fun(Ch, {N, AccM}) ->
        {N + 1, AccM#{{Ch, N} => maps:get({Ch, N}, AccM, 0) + 1}}
      end, {0, M}, Line),
    most_frequent(Lines, L, NewM).
