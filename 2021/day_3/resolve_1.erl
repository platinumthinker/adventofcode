#!/usr/bin/env escript
-module(resolve).
-export([main/1]).

main([]) ->
	erlang:display( count(read_stdin(), lists:duplicate(12, #{})) ).

read_stdin() -> read_stdin(io:get_line(""), []).
read_stdin(eof,  L) -> lists:reverse(L);
read_stdin(Line, T) -> read_stdin(io:get_line(""), [string:trim(Line)| T]).

count([], M) -> {G, E} = to_digit(M, "", ""), G * E;
count([H | T], M) -> count(T, offen(H, M, [])).

offen([], [], Acc) -> lists:reverse(Acc);
offen([H1 | T1], [H2 | T2], Acc) -> offen(T1, T2, [H2#{H1 => maps:get(H1, H2, 0) + 1} | Acc]).

dig(L) -> {ok, [D], []} = io_lib:fread("~#", "2#" ++ L), D.
to_digit([], Acc1, Acc2) -> {dig(lists:reverse(Acc1)), dig(lists:reverse(Acc2))};
to_digit([H | T], Acc1, Acc2) ->
	#{$1 := V1, $0 := V2} = H,
	case V1 > V2 of
		true -> to_digit(T, [$1 | Acc1], [$0 | Acc2]);
		false -> to_digit(T, [$0 | Acc1], [$1 | Acc2])
	end.
