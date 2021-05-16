-module(hhs_user_server).

-behaviour(gen_server).

-export([
    start_link/0,
    authenticate/4,
    remember_me_login/2,
    logout/2,
    register_user/3,
    user_exists/1,
    email_registered/1,
    remove_old_remember_me_tokens/0
]).

-export([
    init/1,
    handle_continue/2,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-include_lib("stdlib/include/qlc.hrl").
-include("hhs_internal.hrl").

%%
%% API
%%

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

authenticate(Username, Password, RememberMe, OldRememberMeSeries) ->
    case get_user(Username) of
        {ok, User} ->
            PasswordHash = User#hhs_user.password_hash,
            case erlpass:match(Password, PasswordHash) of
                true ->
                    % remove the old remember-me token from the database
                    Tokens = lists:keydelete(
                        OldRememberMeSeries,
                        1,
                        User#hhs_user.remember_me_tokens
                    ),

                    {Token, NewTokens} =
                        case RememberMe of
                            true ->
                                RememberMeToken = generate_remember_me_token(),
                                {RememberMeToken, [RememberMeToken | Tokens]};
                            false ->
                                {nil, Tokens}
                        end,

                    mnesia:transaction(fun() ->
                        mnesia:write(User#hhs_user{remember_me_tokens = NewTokens})
                    end),
                    {ok, User#hhs_user.roles, Token};
                _ ->
                    {error, bad_auth}
            end;
        {error, no_such_user} ->
            {error, bad_auth}
    end.

remember_me_login(Series, Token) ->
    case get_user_by_remember_me_series(Series) of
        {error, no_such_user} ->
            {error, bad_series};
        {ok, User} ->
            case lists:keyfind(Series, 1, User#hhs_user.remember_me_tokens) of
                {Series, Token, _LastUsed} ->
                    NewToken = generate_remember_me_token(Series),
                    NewTokens = lists:keystore(
                        Series,
                        1,
                        User#hhs_user.remember_me_tokens,
                        NewToken
                    ),
                    mnesia:transaction(fun() ->
                        mnesia:write(User#hhs_user{remember_me_tokens = NewTokens})
                    end),
                    {ok, User#hhs_user.username, User#hhs_user.roles, NewToken};
                % non maching token -> theft assumed
                _ ->
                    mnesia:transaction(fun() ->
                        mnesia:write(User#hhs_user{remember_me_tokens = []})
                    end),
                    {error, bad_token}
            end
    end.

logout(Username, RememberMeSeries) ->
    case get_user(Username) of
        {ok, User} ->
            Tokens = lists:keydelete(RememberMeSeries, 1, User#hhs_user.remember_me_tokens),
            mnesia:transaction(fun() ->
                mnesia:write(User#hhs_user{remember_me_tokens = Tokens})
            end);
        {error, no_such_user} ->
            ok
    end.

register_user(Username, Password, Email) ->
    PWHash = erlpass:hash(Password),
    User = #hhs_user{
        username = Username,
        password_hash = PWHash,
        email = Email,
        roles = [password, user]
    },

    F = fun() ->
        case {get_user(Username), get_user_by_email(Email)} of
            {{ok, _}, _} ->
                mnesia:abort(user_already_exists);
            {_, {ok, _}} ->
                mnesia:abort(email_already_registered);
            _ ->
                mnesia:write(User)
        end
    end,

    case mnesia:transaction(F) of
        {aborted, user_already_exists} ->
            {error, user_already_exists};
        {aborted, email_already_registered} ->
            {error, email_already_registered};
        {atomic, ok} ->
            {ok, User}
    end.

user_exists(Username) ->
    case get_user(Username) of
        {ok, _User} ->
            true;
        {error, no_such_user} ->
            false
    end.

email_registered(Email) ->
    case get_user_by_email(Email) of
        {ok, _User} ->
            true;
        {error, no_such_user} ->
            false
    end.

remove_old_remember_me_tokens() ->
    gen_server:cast(?MODULE, remove_old_remember_me_tokens).

%%
%% Callbacks
%%

init([]) ->
    {ok, #{}, {continue, db_init}}.

handle_continue(db_init, State) ->
    Options = [
        {type, set},
        {access_mode, read_write},
        {disc_copies, []},
        {attributes, record_info(fields, hhs_user)}
    ],
    {atomic, ok} = mnesia:create_table(hhs_user, Options),
    {noreply, State}.

handle_call(_Msg, _From, State) ->
    {noreply, State}.

handle_cast(remove_old_remember_me_tokens, State) ->
    LocalTimeSeconds = calendar:datetime_to_gregorian_seconds(erlang:localtime()),
    mnesia:transaction(fun() ->
        UsersToUpdate = mnesia:foldl(
            fun(User, Acc) ->
                Tokens = lists:filter(
                    fun({_, _, LastUsed}) ->
                        (LocalTimeSeconds - calendar:datetime_to_gregorian_seconds(LastUsed)) / 60 =<
                            ?REMEMBER_ME_TTL
                    end,
                    User#hhs_user.remember_me_tokens
                ),

                case Tokens =/= User#hhs_user.remember_me_tokens of
                    true -> [User#hhs_user{remember_me_tokens = Tokens} | Acc];
                    false -> Acc
                end
            end,
            [],
            hhs_user
        ),

        lists:foreach(fun(User) -> mnesia:write(User) end, UsersToUpdate)
    end),
    {noreply, State};
handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%
%% Private
%%

generate_remember_me_token() ->
    Series = bin_to_hexstr(crypto:strong_rand_bytes(16)),
    case get_user_by_remember_me_series(Series) of
        {ok, _User} ->
            generate_remember_me_token();
        {error, no_such_user} ->
            generate_remember_me_token(Series)
    end.

generate_remember_me_token(Series) ->
    {Series, bin_to_hexstr(crypto:strong_rand_bytes(16)), erlang:localtime()}.

get_user_by_remember_me_series(Series) ->
    F = fun() ->
        qlc:e(
            qlc:q([
                U
                || U <- mnesia:table(hhs_user),
                   lists:keyfind(Series, 1, U#hhs_user.remember_me_tokens) =/= false
            ])
        )
    end,
    case mnesia:transaction(F) of
        {atomic, []} -> {error, no_such_user};
        {atomic, [User]} -> {ok, User}
    end.

bin_to_hexstr(Bin) ->
    lists:flatten([io_lib:format("~2.16.0b", [X]) || X <- binary_to_list(Bin)]).

get_user(Username) ->
    case mnesia:transaction(fun() -> mnesia:read({hhs_user, Username}) end) of
        {atomic, []} ->
            {error, no_such_user};
        {atomic, [User]} ->
            {ok, User}
    end.

get_user_by_email(Email) ->
    F = fun() ->
        qlc:e(
            qlc:q([
                U
                || U <- mnesia:table(hhs_user),
                   U#hhs_user.email == Email
            ])
        )
    end,

    case mnesia:transaction(F) of
        {atomic, []} -> {error, no_such_user};
        {atomic, [User]} -> {ok, User}
    end.
