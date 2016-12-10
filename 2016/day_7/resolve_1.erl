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
                   abba(binary_to_list(L), true, true) andalso
                   abba(binary_to_list(L), false, false) ],
    erlang:display(length(Lines)).

abba([ Ch | Tail ], F, F1) when Ch == $]; Ch == $[ -> abba(Tail, not F, F1);
abba([ C1, C2, C2, C1  | _], true, F) when C1 /= C2 -> F;
abba([ _ | Tail ], F, F1) -> abba(Tail, F, F1);
abba([], _, F) -> not F.
