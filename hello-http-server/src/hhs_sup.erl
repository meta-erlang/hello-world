%%%-------------------------------------------------------------------
%% @doc hhs top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(hhs_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    SupFlags = #{
        strategy => one_for_one,
        intensity => 5,
        period => 10
    },

    UserServer = #{
        id => hhs_user_server,
        start => {hhs_user_server, start_link, []},
        restart => permanent,
        shutdown => 5000,
        type => worker,
        modules => [hhs_user_server]
    },

    ChildSpecs = [UserServer],

    {ok, {SupFlags, ChildSpecs}}.

%% internal functions
