#!/usr/bin/env escript
-module(resolve).
-export([main/1]).

main([]) ->
	{In, Cards} = read_stdin(),
	Res = count(Cards, In, 1, []),
	erlang:display( lists:nth(1, lists:keysort(2, Res) ) ).

read_stdin() -> read_stdin(string:trim(io:get_line("")), first, {[], [], []}).
read_stdin(eof,  _, {L1, _, L2}) -> {L1, lists:reverse(L2)};
read_stdin(Line, first, {_, Acc2, Acc3}) ->
	L = [ list_to_integer(X) || X <- string:split(Line, ",", all) ],
	io:get_line(""),
	read_stdin(io:get_line(""), second, {L, Acc2, Acc3});
read_stdin("\n", Cmd, {L, Acc2, Acc3}) ->
	read_stdin(io:get_line(""), Cmd, {L, [], [Acc2 | Acc3] } );
read_stdin(Line, Cmd, {L, Acc2, Acc3}) ->
	L1 = [ list_to_integer(X) || X <- string:split(string:trim(Line), " ", all), X /= [] ],
	read_stdin(io:get_line(""), Cmd, {L, [L1 | Acc2], Acc3}).

count([], _, _, Res) -> lists:reverse(Res);
count([H | T], In, N, Acc) ->
	{Steps, Score} = points(H, In, 1),
	count(T, In, N + 1, [{N, Steps, Score} | Acc]).

points(_, In, N) when N == length(In) -> {length(In), 0};
points(Card, In, Step) ->
	{Input, _} = lists:split(Step, In),
	case win_vertical(Card, Input) orelse
	     win_horizontal(Card, Input) of
		true -> {Step, count_points(Card, Input)};
		false -> points(Card, In, Step + 1)
	end.

count_points(Card, In) ->
	lists:sum([X || X <- lists:flatten(Card), not lists:member(X, In)]) * lists:last(In).

win_vertical([], _) -> false;
win_vertical([Column | T], In) ->
	case length([X || X <- Column, lists:member(X, In)]) of
		5 -> true;
		_ -> win_vertical(T, In)
	end.

win_horizontal(Card, In) -> win_horizontal(Card, 1, In).
win_horizontal(_, 6, _) -> false;
win_horizontal(Card, Row, In) ->
	case length([lists:nth(Row, X) || X <- Card, lists:member(lists:nth(Row, X), In)]) of
		5 -> true;
		_ -> win_horizontal(Card, Row + 1, In)
	end.
