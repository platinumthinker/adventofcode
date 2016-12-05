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

main([Id]) ->
    erlang:display(find(Id, 0, "", 8)).

find(_, _, Acc, 0) -> lists:reverse(Acc);
find(Id, Key, Acc, N) ->
    Key1 = Key + 1,
    case test(Id, Key) of
        false -> find(Id, Key1, Acc, N);
        Ch -> find(Id, Key1, [Ch | Acc], N - 1)
    end.

test(Str, Id) ->
    Hash = crypto:hash(md5, [Str | integer_to_list(Id)]),
    Pass = lists:flatten(
      [ io_lib:format("~2.16.0B",[X]) || <<X:8>> <= Hash ]
       ),
    case lists:prefix("00000", Pass) of
        true -> A = lists:nth(6, Pass), erlang:display([A]), A;
        _ -> false
    end.

