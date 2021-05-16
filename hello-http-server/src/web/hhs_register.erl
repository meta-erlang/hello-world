-module(hhs_register).
-compile(export_all).
-include("hhs.hrl").

main() ->
    #template{file = code:priv_dir(hello_http_server) ++ "/templates/base.html"}.

title() -> "Register - Create Acount".

header() ->
    hhs_common:header(register).

content() ->
    #panel{
        body = [
            #panel{class = row, body = #panel{class = "column column-100", body = register()}}
        ]
    }.

register() ->
    wf:wire(submit, username, #validate{
        attach_to = username_status,
        validators = [
            #is_required{text = "Required"},
            #custom{
                text = "Invalid username",
                function = fun matches/2,
                tag = "^[a-z][a-z0-9_-]{1,6}[a-z0-9]$"
            },
            #custom{text = "Username already registered", function = fun user_not_exists/2}
        ]
    }),
    wf:wire(submit, password, #validate{
        attach_to = password_status,
        validators = [
            #is_required{text = "Required"},
            #min_length{text = "Must have at least 8 characters", length = 8},
            #custom{
                text = "Must have at least one lower-case character",
                function = fun matches/2,
                tag = "[a-z]"
            },
            #custom{
                text = "Must have at least one upper-case character",
                function = fun matches/2,
                tag = "[A-Z]"
            },
            #custom{text = "Must have at least one digit", function = fun matches/2, tag = "[0-9]"}
        ]
    }),
    wf:wire(submit, confirm_password, #validate{
        attach_to = confirm_password_status,
        validators = [
            #is_required{text = "Required"},
            #confirm_password{text = "Passwords must match", password = password}
        ]
    }),
    wf:wire(submit, email, #validate{
        attach_to = email_status,
        validators = [
            #is_required{text = "Required"},
            #is_email{text = "Not a valid e-mail address"},
            #custom{
                text = "E-mail address already registered",
                function = fun email_not_registered/2
            }
        ]
    }),

    [
        #label{for = username, text = "Username:"},
        #textbox{id = username, next = password},
        #span{id = username_status},

        #label{for = password, text = "Password:"},
        #password{id = password, next = confirm_password},
        #span{id = password_status},

        #label{for = confirm_password, text = "Confirm Password:"},
        #password{id = confirm_password, next = email},
        #span{id = confirm_password_status},

        #label{for = email, text = "Email:"},
        #textbox{id = email, next = submit},
        #span{id = email_status},

        #button{id = submit, text = "Create Account", postback = register_user}
    ].

event(register_user) ->
    [Username, Password, Email] = wf:mq([username, password, email]),
    case hhs_user_server:register_user(Username, Password, Email) of
        {ok, _User} ->
            wf:redirect_to_login("/hhs/login", "/hhs/index");
        error ->
            wf:flash("Somebody registered your email or username after validation.")
    end.

matches(Regex, String) ->
    case re:run(String, Regex) of
        {match, _} -> true;
        nomatch -> false
    end.

user_not_exists(_Tag, Username) ->
    not hhs_user_server:user_exists(Username).

email_not_registered(_Tag, Email) ->
    not hhs_user_server:email_registered(Email).
