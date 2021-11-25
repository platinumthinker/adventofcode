#!/usr/bin/env escript
-module(resolve).
-export([main/1]).

-mode(compile).

main([Num, N]) ->
	I = [ list_to_integer([H]) || H <- Num ],
	erlang:display(I),
	retry(I, list_to_integer(N)).

retry(L, 0) -> erlang:display(length(L));
retry([H | T], Count) ->
	NextStep = look_and_say(T, {H, 1}, []),
	retry(NextStep, Count - 1).

look_and_say([], {Y, Count}, C) -> lists:reverse([Y, Count | C]);
look_and_say([H|T], {H, Count} , C) -> look_and_say(T, {H, Count + 1}, C);
look_and_say([H|T], {Y, Count} , C) -> look_and_say(T, {H, 1}, [Y, Count | C]).
