-module(hello).

-behaviour(gen_server).

-export([start_link/0]).

-export([init/1,
         terminate/2,
         code_change/3,
         handle_call/3,
         handle_cast/2,
         handle_info/2]).

-define(PERIOD, 10000).

start_link() ->
  gen_server:start_link(?MODULE, [], []).

init([]) ->
  {ok, 0, ?PERIOD}.

handle_call(_, _, N) -> {noreply, N}.

handle_cast(_, N) -> {noreply, N}.

handle_info(timeout, N) ->
  ok = error_logger:info_msg("Hello~n"),
  {noreply, N + 1, ?PERIOD}.

code_change(_, N, _) -> {ok, N}.

terminate(_, _) -> ok.
