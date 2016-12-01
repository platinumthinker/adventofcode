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

turn(Turns)    -> turn(Turns, {0, 0, 0}, []).
turn([], _, _) -> {undefined, undefined};
turn([{Dir, Steps} | Tail], {X, Y, Z}, Path) ->
    Z1 = dir(Dir, Z),
    Key = {X1, Y1} = direct_turn(Steps, X, Y, Z1),
    case intersect(X, Y, X1, Y1, Path) of
        false -> turn(Tail, {X1, Y1, Z1}, [ {{X, Y}, Key} | Path ]);
        {X2, Y2} ->
            {X2, Y2}
    end.

direct_turn(Steps, X, Y, 0) -> {X + Steps, Y};
direct_turn(Steps, X, Y, 1) -> {X, Y + Steps};
direct_turn(Steps, X, Y, 2) -> {X - Steps, Y};
direct_turn(Steps, X, Y, 3) -> {X, Y - Steps}.

dir(l, 0) -> 3;
dir(l, A) -> A - 1;
dir(r, A) -> (A + 1) rem 4.

intersect(X, Y, X1, Y1, Path) ->
    intersect(X, Y, X1, Y1, Path, []).
intersect(_, _, _, _, [], [])  -> false;
intersect(X, Y, _, _, [], Acc) -> find_nearest(X, Y, Acc);
intersect(X0, Y0, X1, Y1, [ {{X0, Y0}, _} | Path ], Acc) ->
    intersect(X0, Y0, X1, Y1, Path, Acc);
intersect(X0, Y0, X1, Y1, [ {_, {X0, Y0}} | Path ], Acc) ->
    intersect(X0, Y0, X1, Y1, Path, Acc);
intersect(X0, Y0, X1, Y1, [ {{X1, Y1}, _} | Path ], Acc) ->
    intersect(X0, Y0, X1, Y1, Path, Acc);
intersect(X0, Y0, X1, Y1, [ {_, {X1, Y1}} | Path ], Acc) ->
    intersect(X0, Y0, X1, Y1, Path, Acc);
intersect(X0, Y0, X1, Y1, [ Point2 = {{X2, Y2}, {X3, Y3}} | Path ], Acc) ->
    X10 = X1 - X0, Y10 = Y1 - Y0,
    X32 = X3 - X2, Y32 = Y3 - Y2,
    D = X10 * Y32 - X32 * Y10,
    Res = case (D == 0) of
        true  -> false;
        false ->
            Sign = D > 0,
            X02 = X0 - X2,
            Y02 = Y0 - Y2,
            S_Num = X10 * Y02 - Y10 * X02,
            case ((S_Num < 0) == Sign) of
                true  -> false;
                false ->
                    T_Num = X32 * Y02 - Y32 * X02,
                    case ((T_Num < 0) == Sign) of
                        true  -> false;
                        false ->
                            not ((S_Num > D) == Sign orelse
                               (T_Num > D) == Sign)
                    end
            end
    end,

    case Res of
        true ->
            intersect(X0, Y0, X1, Y1, Path, [Point2 | Acc]);
        false ->
            intersect(X0, Y0, X1, Y1, Path, Acc)
    end.

find_nearest(X, Y, Path) ->
    find_nearest(X, Y, Path, inf, {0, 0}).
find_nearest(_, _, [], _, Res) -> Res;
find_nearest(X, Y, [ {{_, Y1}, {_, Y1}} | Path ], Dist, Acc) ->
    Dist1 = abs(Y - Y1),
    case (Dist > Dist1) of
        true ->
            find_nearest(X, Y, Path, Dist1, {X, Y1});
        false ->
            find_nearest(X, Y, Path, Dist, Acc)
    end;
find_nearest(X, Y, [ {{X1, _}, {X1, _}} | Path ], Dist, Acc) ->
    Dist1 = abs(X - X1),
    case (Dist > Dist1) of
        true ->
            find_nearest(X, Y, Path, Dist1, {X1, Y});
        false ->
            find_nearest(X, Y, Path, Dist, Acc)
    end.
