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

-define(INPUT, "R2, L3, R2, R4, L2, L1, R2, R4, R1, L4, L5, R5, R5, R2, R2, R1, L2, L3, L2, L1, R3, L5, R187, R1, R4, L1, R5, L3, L4, R50, L4, R2, R70, L3, L2, R4, R3, R194, L3, L4, L4, L3, L4, R4, R5, L1, L5, L4, R1, L2, R4, L5, L3, R4, L5, L5, R5, R3, R5, L2, L4, R4, L1, R3, R1, L1, L2, R2, R2, L3, R3, R2, R5, R2, R5, L3, R2, L5, R1, R2, R2, L4, L5, L1, L4, R4, R3, R1, R2, L1, L2, R4, R5, L2, R3, L4, L5, L5, L4, R4, L2, R1, R1, L2, L3, L2, R2, L4, R3, R2, L1, L3, L2, L4, L4, R2, L3, L3, R2, L4, L3, R4, R3, L2, L1, L4, R4, R2, L4, L4, L5, L1, R2, L5, L2, L3, R2, L2").

main(_Args) ->
    TURNS = [ parse(Turn) || Turn <- string:tokens(?INPUT, ", ") ],
    {X, Y} = turn(TURNS),
    erlang:display(abs(X) + abs(Y)),
    ok.

parse([$L | Steps]) ->
    {l, list_to_integer(Steps)};
parse([$R | Steps]) ->
    {r, list_to_integer(Steps)}.

turn(Turns) -> turn(Turns, {0, 0, 0}).
turn([], {X, Y, _}) -> {X, Y};
turn([{Dir, Steps} | Tail], {X, Y, Z}) ->
    {X1, Y1} = direct_turn(Steps, X, Y, Z),
    turn(Tail, {X1, Y1, dir(Dir, Z)}).

direct_turn(Steps, X, Y, 0) -> {X + Steps, Y};
direct_turn(Steps, X, Y, 1) -> {X, Y + Steps};
direct_turn(Steps, X, Y, 2) -> {X - Steps, Y};
direct_turn(Steps, X, Y, 3) -> {X, Y - Steps}.

dir(l, 0) -> 3;
dir(l, A) -> A - 1;
dir(r, A) -> (A + 1) rem 4.
