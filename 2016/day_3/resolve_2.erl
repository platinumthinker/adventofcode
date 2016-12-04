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
    Lines1 = tran(Lines),
    A = [ ABC || ABC <- Lines1, tr(ABC) ],
    erlang:display(erlang:length(A)).

tr([A, B, C]) ->
    tr([ binary_to_integer(A),
         binary_to_integer(B),
         binary_to_integer(C)
       ], 0).
tr([A, B, C], 2) -> A + B > C;
tr([A, B, C], Try) when A + B > C ->
    tr([B, C, A], Try + 1);
tr(_, _) -> false.

tran(L) -> tran(L, []).
tran([], Acc) -> Acc;
tran([[A1, B1, C1], [A2, B2, C2], [A3, B3, C3] | T], Acc) ->
tran( T, [[A1, A2, A3], [B1, B2, B3], [C1, C2, C3] | Acc]).
