-module(hello_sup).

-behaviour(supervisor).

-export([start_link/0, init/1]).

-define(SERVER, ?MODULE).

start_link() ->
  ChildSpecs = [{hello_log, {hello, start_link, []},
                 permanent, brutal_kill, worker, [hello]}],
  supervisor:start_link({local, ?SERVER}, ?MODULE, ChildSpecs).

init(ChildSpecs) ->
  {ok, {{one_for_one, 1, 5}, ChildSpecs}}.

   %% {#{strategy  => one_for_one,
   %%   intensity => 1,
   %%   period    => 5},
   %% [#{id       => hello_log,
   %%    start    => {hello, start, []},
   %%    restart  => permanent,
   %%    shutdown => brutal_kill,
   %%    type     => worker,
   %%    modules  => [hello]}]}
