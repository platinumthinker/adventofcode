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
    Lines = binary:split(Input, <<"\n">>, [global, trim]),
    Keys = lists:reverse([
            [ "0", "0", "1", "0", "0" ],
            [ "0", "2", "3", "4", "0" ],
            [ "5", "6", "7", "8", "9" ],
            [ "0", "A", "B", "C", "0" ],
            [ "0", "0", "D", "0", "0" ]
           ]),
    lists:foldl(fun(Num, Acc) -> num(Num, Acc, Keys) end, {1, 3}, Lines).

num(<<>>, {X, Y}, Keys) ->
    io:format("~s~n", [eval(X, Y, Keys)]),
    {X, Y};
num(<<"U", T/binary>>, {X, Y}, Keys) ->
    case eval(X, Y - 1, Keys) of
        "0" ->
            num(T, {X, Y}, Keys);
        _ ->
            num(T, {X, Y - 1}, Keys)
    end;
num(<<"D", T/binary>>, {X, Y}, Keys) ->
    case eval(X, Y + 1, Keys) of
        "0" ->
            num(T, {X, Y}, Keys);
        _ ->
            num(T, {X, Y + 1}, Keys)
    end;
num(<<"L", T/binary>>, {X, Y}, Keys) ->
    case eval(X - 1, Y, Keys) of
        "0" ->
            num(T, {X, Y}, Keys);
        _ ->
            num(T, {X - 1, Y}, Keys)
    end;
num(<<"R", T/binary>>, {X, Y}, Keys) ->
    case eval(X + 1, Y, Keys) of
        "0" ->
            num(T, {X, Y}, Keys);
        _ ->
            num(T, {X + 1, Y}, Keys)
    end.

eval(X, Y, _Keys) when X < 1 orelse Y < 1 -> "0";
eval(X, Y, _Keys) when X > 5 orelse Y > 5 -> "0";
eval(X, Y, Keys) ->
    lists:nth(Y, lists:nth(X, lists:reverse(Keys))).
