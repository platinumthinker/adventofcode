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
    io:format("~s~n", [find(Id, 0, #{}, 8)]).

find(_, _, Acc, 0) -> [ Ch || {_, Ch} <- maps:to_list(Acc) ] ;
find(Id, Key, Acc, N) ->
    Key1 = Key + 1,
    case test(Id, Key) of
        false -> find(Id, Key1, Acc, N);
        {NN, Ch} ->
            case maps:is_key(NN, Acc) of
                true  -> find(Id, Key1, Acc, N);
                false -> find(Id, Key1, Acc#{NN => Ch}, N - 1)
            end
    end.

test(Str, Id) ->
    Hash = crypto:hash(md5, [Str | integer_to_list(Id)]),
    Pass = lists:flatten(
             [ io_lib:format("~2.16.0B",[X]) || <<X:8>> <= Hash ]
       ),
    case lists:prefix("00000", Pass) of
        true ->
            case lists:nth(6, Pass) - $0 of
                A when A >= 0 andalso A < 8 ->
                    {A, lists:nth(7, Pass)};
                _ ->
                    false
            end;
        _ -> false
    end.

