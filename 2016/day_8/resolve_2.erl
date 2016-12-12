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
    [ put({X,Y}, off) || X <- lists:seq(1, 50), Y <- lists:seq(1, 6) ],
    [ begin resolve(L), display_draw() end || L <- binary:split(Input, <<"\n">>, [global, trim_all])],
    erlang:display(display_on()).

resolve(<<"rect ", T/binary>>) ->
    {X, Y} = parse(T, <<"x">>),
    [ put({X1,Y1}, on) || X1 <- lists:seq(1, X), Y1 <- lists:seq(1, Y) ];
resolve(<<"rotate row y=", T/binary>>) ->
    {Y, N} = parse(T, <<" by ">>),
    Data = shift([ get({X, Y + 1}) || X <- lists:seq(1, 50) ], N),
    [ put({X, Y + 1}, lists:nth(X, Data)) || X <- lists:seq(1, 50) ],
    io:format("Rotate y ~p ~p~n", [Y, N]);
resolve(<<"rotate column x=", T/binary>>) ->
    {X, N} = parse(T, <<" by ">>),
    Data = shift([ get({X + 1, Y}) || Y <- lists:seq(1, 6) ], N),
    [ put({X + 1, Y}, lists:nth(Y, Data)) || Y <- lists:seq(1, 6) ],
    io:format("Rotate x ~p ~p~n", [X, N]).

shift(List, 0) -> List;
shift(List, N) ->
    Last = lists:last(List),
    Other = lists:sublist(List, 1, length(List) - 1),
    shift([Last | Other], N - 1).

display_on() -> length(erlang:get_keys(on)).
display_draw() ->
    [ begin
          X == 1 andalso io:format("~n"),
          case get({X,Y}) of
              on -> io:format("#");
              off -> io:format(".")
          end
      end
      || Y <- lists:seq(1, 6), X <- lists:seq(1, 50) ],
    io:format("~n").
parse(In, Split) ->
    [A, B] = binary:split(In, Split, [global, trim_all]),
    {binary_to_integer(A), binary_to_integer(B)}.
