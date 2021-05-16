-module(hhs_login).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("hhs.hrl").

main() ->
    #template{file = code:priv_dir(hello_http_server) ++ "/templates/login.html"}.

title() -> "Login".

login() ->
    wf:wire(submit, username, #validate{
        attach_to = username_status,
        validators = [#is_required{text = "Required"}]
    }),
    wf:wire(submit, password, #validate{
        attach_to = password_status,
        validators = [#is_required{text = "Required"}]
    }),

    #panel{
        class = "",
        body = [
            #flash{},

            #label{for = username, text = "Username:"},
            #textbox{id = username, next = password},
            #span{id = username_status},

            #label{for = password, text = "Password:"},
            #password{id = password, next = submit},
            #span{id = password_status},

            #panel{
                class = "float-right",
                body = [
                    #checkbox{id = remember_me, label_position = none},
                    #label{class = "inline", for = remember_me, text = "Remember Me"}
                ]
            },
            #button{id = submit, text = "Login", postback = login}
        ]
    }.

event(login) ->
    [Username, Password] = wf:mq([username, password]),

    RememberMe =
        case wf:q(remember_me) of
            "on" -> true;
            _ -> false
        end,

    % get the old remember-me cookie for removal from the database
    OldRememberMeSeries =
        case wf:cookie(remember_me_token) of
            undefined -> "";
            Token -> hd(string:tokens(Token, ":"))
        end,

    case hhs_user_server:authenticate(Username, Password, RememberMe, OldRememberMeSeries) of
        {error, bad_auth} ->
            % close any existing notification flashes
            case wf:state(flash_id) of
                undefined ->
                    ok;
                OldFlashId ->
                    wf:wire(OldFlashId, #hide{effect = blind, speed = 100})
            end,

            % remember the id of the message that is about to be displayed
            FlashId = wf:temp_id(),
            wf:state(flash_id, FlashId),

            wf:state(attempts, wf:state_default(attempts, 0) + 1),
            case wf:state(attempts) == 5 of
                true ->
                    wf:flash(FlashId, "Are you a robot?"),
                    wf:state(attempts, 0);
                false ->
                    wf:flash(FlashId, "Invalid username or password.")
            end;
        {ok, Roles, RememberMeToken} ->
            wf:user(Username),
            lists:foreach(fun(Role) -> wf:role(Role, true) end, Roles),
            case RememberMeToken of
                nil ->
                    wf:cookie(remember_me_token, "", "/", 0);
                {Series, Value, _LastUsed} ->
                    wf:cookie(remember_me_token, Series ++ ":" ++ Value, "/", ?REMEMBER_ME_TTL)
            end,
            wf:redirect_from_login("/hhs/main")
    end.

%% modified from action_redirect.erl
%% required because requests are rewritten: / -> /epkgblender
%% XXX: this is a hack
%% remove "/epkgblender" from the URI
redirect_from_login(DefaultUrl) ->
    PickledURI = wf:q(x),
    case wf:depickle(PickledURI) of
        undefined -> action_redirect:redirect(DefaultUrl);
        Other -> action_redirect:redirect(re:replace(Other, "/epkgblender", "", [{return, list}]))
    end.
