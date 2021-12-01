#!/usr/bin/env escript
-module(resolve).
-export([main/1]).

-mode(compile).

main([]) -> 
	erlang:display(count(read_stdin(), 0)).

read_stdin() -> read_stdin(io:get_line(""), []).
read_stdin(eof,  L) -> lists:reverse(L);
read_stdin(Line, L) -> 
	Number = list_to_integer(string:trim(Line)),
	read_stdin(io:get_line(""), [Number | L]).

count([], IncreasingCount) -> IncreasingCount;
count([H1, H2 | T], IncreasingCount) when H2 > H1 ->
	count([H2 | T], IncreasingCount + 1);
count([_ | T], IncreasingCount) ->
	count(T, IncreasingCount).
