-module(hhs_security_handler).
-behaviour(security_handler).
-export([init/2, finish/2]).

-include("hhs_internal.hrl").

init(_Config, State) -> 
    User = wf:user(),
    attempt_cookie_login(User),
    {ok, State}.

finish(_Config, State) -> 
    {ok, State}.


attempt_cookie_login(undefined) ->
    case string:tokens(wf:cookie_default(remember_me_token, ""), ":") of
        [Series, Token] ->
            case hhs_user_server:remember_me_login(Series, Token) of
                {ok, User, Roles, {Series, NewToken, _LastUsed}} ->
                    wf:user(User),
                    lists:foreach(fun(Role) -> wf:role(Role, true) end, Roles),
                    wf:cookie(remember_me_token, Series ++ ":" ++ NewToken, "/", ?REMEMBER_ME_TTL);
                {error, bad_series} ->
                    wf:cookie(remember_me_token, "", "/", 0);
                {error, bad_token} ->  % theft assumed
                    wf:cookie(remember_me_token, "", "/", 0),
                    wf_context:page_module(hhs_login)
                end;
        _ ->
            ok  % invalid cookie, but it's not worth erasing
    end;

attempt_cookie_login(_) ->
    ok.

