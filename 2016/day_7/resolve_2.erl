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
    Lines = [ L || L <- binary:split(Input, <<"\n">>, Opts),
                   bab(binary_to_list(L),
                       aba(binary_to_list(L), [], true), false)],
    erlang:display(length(Lines)).

aba([ Ch | Tail ], T2, F) when Ch == $]; Ch == $[ -> aba(Tail, T2, not F);
aba([ C1, C2, C1  | T], T2, true) when C1 /= C2 ->
    aba([C2, C1 | T], [[C2, C1, C2] | T2], true);
aba([ _ | Tail ], T2, F) -> aba(Tail, T2, F);
aba([], T, _F) -> T.

bab([ Ch | Tail ], T2, F) when Ch == $]; Ch == $[ -> bab(Tail, T2, not F);
bab([ C1, C2, C1  | T], T2, true) when C1 /= C2 ->
    case lists:member([C1, C2, C1], T2) of
        true  -> true;
        false -> bab([C2, C1 | T], T2, true)
    end;
bab([ _ | Tail ], T2, F) -> bab(Tail, T2, F);
bab([], _, _F) -> false.
