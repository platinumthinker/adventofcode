#!/usr/bin/env escript
-module(resolve).
-export([main/1]).

main([]) ->
	erlang:display( retry(read_stdin()) ).

read_stdin() -> read_stdin(io:get_line(""), []).
read_stdin(eof,  L) -> lists:reverse(L);
read_stdin(Line, T) -> read_stdin(io:get_line(""), [string:trim(Line)| T]).

retry(L) -> retry(L, 1, L, {$0, $1}).
retry([L], _, L1, {$0, $1}) -> dig(L) * retry(L1, 1, L1, {$1, $0});
retry([L], _, _, _) -> dig(L);
retry(L, N, L1, Cmp) ->
	O = offen(L, N, #{}, Cmp),
	NewL = [X || X <- L, lists:nth(N, X) == O],
	retry(NewL, N + 1, L1, Cmp).

offen([], _, M, {Ch1, Ch2}) ->
	#{$1 := V1, $0 := V2} = M,
	case V1 < V2 of
		true -> Ch1;
		false -> Ch2
	end;
offen([H | T], Nth, M, Cmp) ->
	K = lists:nth(Nth, H),
	offen(T, Nth, M#{K => maps:get(K, M, 0) + 1}, Cmp).

dig(L) -> {ok, [D], []} = io_lib:fread("~#", "2#" ++ L), D.
