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
    lists:foldl(fun(Num, Acc) -> num(Num, Acc) end, 5, Lines).

num(<<>>, N) -> erlang:display(N), N;
num(<<"U", T/binary>>, N) when N < 4        -> num(T, N);
num(<<"D", T/binary>>, N) when N > 6        -> num(T, N);
num(<<"L", T/binary>>, N) when N rem 3 == 1 -> num(T, N);
num(<<"R", T/binary>>, N) when N rem 3 == 0 -> num(T, N);
num(<<"U", T/binary>>, N) -> num(T, N - 3);
num(<<"D", T/binary>>, N) -> num(T, N + 3);
num(<<"L", T/binary>>, N) -> num(T, N - 1);
num(<<"R", T/binary>>, N) -> num(T, N + 1).
