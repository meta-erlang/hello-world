-module(hhs_logout).
-compile(export_all).

main() ->
    case wf:user() of
        undefined ->
            ok;
        User ->
            RememberMeSeries =
                case wf:cookie(remember_me_token) of
                    undefined ->
                        "";
                    Token ->
                        hd(string:tokens(Token, ":"))
                end,
            hhs_user_server:logout(User, RememberMeSeries),
            wf:cookie(remember_me_token, "", "/", 0),
            wf:logout()
    end,
    wf:redirect_to_login("/hhs/login", "/hhs/index").
