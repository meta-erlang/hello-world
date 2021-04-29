%%%-------------------------------------------------------------------
%% @doc hello-erlang-interoperability public API
%% @end
%%%-------------------------------------------------------------------

-module('hello-erlang-interoperability_app').

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    'hello-erlang-interoperability_sup':start_link().

stop(_State) ->
    ok.

%% internal functions
