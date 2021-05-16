-module(hhs_common).
-compile(export_all).
-include("hhs.hrl").

header(Selected) ->
    wf:wire(Selected, #add_class{class = selected}),
    User = wf:user(),
    Body =
        case User of
            undefined ->
                #panel{
                    class = menu,
                    body = [
                        #link{text = "Login", url = "/hhs/login"},
                        #link{text = "Register", url = "/hhs/register"}
                    ]
                };
            _ ->
                #panel{
                    class = menu,
                    body = [
                        #link{id = main, url = "/hhs/main", text = "Main"},
                        #link{id = system, url = "/hhs/system", text = "System"},
                        #link{id = account, url = "/hhs/account", text = "Account"},
                        #link{id = logout, url = "/hhs/logout", text = "Logout"}
                    ]
                }
        end,

    #panel{class = "float-right", body = Body}.

check_role(Role) ->
    case wf:role(Role) of
        true ->
            #template{file = code:priv_dir(hello_http_server) ++ "/templates/base.html"};
        false ->
            wf:redirect_to_login("/hhs/login")
    end.
