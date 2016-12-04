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
    Opts = [global, trim_all],
    Lines = [ binary:split(L, <<" ">>, Opts) ||
              L <- binary:split(Input, <<"\n">>, Opts) ],
    A = [ ABC || ABC <- Lines, tr(ABC) ],
    erlang:display(erlang:length(A)).
    % lists:foldl(fun(Num, Acc) -> is_triangle(Num, Acc) end, 5, Lines).

tr([A, B, C]) ->
    tr([ binary_to_integer(A),
         binary_to_integer(B),
         binary_to_integer(C)
       ], 0).
tr([A, B, C], 2) -> A + B > C;
tr([A, B, C], Try) when A + B > C ->
    tr([B, C, A], Try + 1);
tr(_, _) -> false.





