#!/usr/bin/env escript
-module(resolve).
-export([main/1]).

main([]) -> erlang:display(count(read_stdin(), 0, 0, 0)).

read_stdin() -> read_stdin(io:get_line(""), []).
read_stdin(eof,  L) -> lists:reverse(L);
read_stdin(Line, L) -> 
	[CmdS, Value] = string:split(Line, " "),
	{Number, _} = string:to_integer(Value),
	Res = [{erlang:list_to_atom(CmdS), Number} | L],
	read_stdin(io:get_line(""), Res).

count([], X, Y, _) -> X * Y;
count([{forward, V} | T], X, Y, Aim) ->
	count(T, X + V, Y + V * Aim, Aim);
count([{down, V} | T], X, Y, Aim) ->
	count(T, X, Y, Aim + V);
count([{up, V} | T], X, Y, Aim) ->
	count(T, X, Y, lists:max([Aim - V, 0])). 
