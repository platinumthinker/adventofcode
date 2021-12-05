#!/usr/bin/env escript
-module(resolve).
-export([main/1]).
-define(READ, io:fread("", "~d,~d -> ~d,~d")).

main([]) -> erlang:display( count( fill( read_stdin(), #{}) ) ).

read_stdin() -> read_stdin(?READ, []).
read_stdin({ok, [X1, Y1, X2, Y2]}, Acc) ->
	read_stdin(?READ, [{{X1, Y1}, {X2, Y2}} | Acc]);
read_stdin(eof, Acc) -> Acc.

fill([], Map) -> Map;
fill([{{X1, Y1}, {X2, Y2}} | T], Map) when X1 == X2 orelse Y1 == Y2 ->
	fill( T, fill_one(min(X1, X2), min(Y1, Y2),  max(X2, X1), max(Y1, Y2), Map) );
fill([{{X1, Y1}, {X2, Y2}} | T], Map) when abs(X2 - X1) == abs(Y2 - Y1) ->
	fill( T, fill_diag(X1, Y1, X2, Y2, Map) );
fill([_ | T], Map) -> fill(T, Map).

fill_one(X, Y, X, Y, Map) -> incr({X, Y}, Map);
fill_one(X, Y1, X, Y2, Map) -> fill_one(X, Y1 + 1, X, Y2, incr({X, Y1}, Map) );
fill_one(X1, Y, X2, Y, Map) -> fill_one(X1 + 1, Y, X2, Y, incr({X1, Y}, Map) ).

fill_diag(X, Y, X, Y, Map) -> incr({X, Y}, Map);
fill_diag(X1, Y1, X2, Y2, Map) when X1 > X2 andalso Y1 > Y2 ->
	fill_diag(X1 - 1, Y1 - 1, X2, Y2, incr({X1, Y1}, Map) );
fill_diag(X1, Y1, X2, Y2, Map) when X1 < X2 andalso Y1 > Y2 ->
	fill_diag(X1 + 1, Y1 - 1, X2, Y2, incr({X1, Y1}, Map) );
fill_diag(X1, Y1, X2, Y2, Map) when X1 > X2 andalso Y1 < Y2 ->
	fill_diag(X1 - 1, Y1 + 1, X2, Y2, incr({X1, Y1}, Map) );
fill_diag(X1, Y1, X2, Y2, Map) when X1 < X2 andalso Y1 < Y2 ->
	fill_diag(X1 + 1, Y1 + 1, X2, Y2, incr({X1, Y1}, Map) ).

incr(K, Map) -> Map#{K => maps:get(K, Map, 0) + 1}.

count(M) -> length([X || X <- maps:values(M), X > 1]).
