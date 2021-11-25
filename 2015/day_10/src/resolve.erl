-module(resolve).
-export([main/1]).

-mode(compile).

main(_Args) ->
	retry([3,1,1,3,3,2,2,1,1,3], 50).

retry(L, 0) -> erlang:display(length(L));
retry([H | T], Count) ->
	NextStep = look_and_say(T, {H, 1}, []),
	retry(NextStep, Count - 1).

look_and_say([], {Y, Count}, C) -> lists:reverse([Y, Count | C]);
look_and_say([H|T], {H, Count} , C) -> look_and_say(T, {H, Count + 1}, C);
look_and_say([H|T], {Y, Count} , C) -> look_and_say(T, {H, 1}, [Y, Count | C]).
