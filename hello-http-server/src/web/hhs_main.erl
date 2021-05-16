-module(hhs_main).
-compile(export_all).
-include("hhs.hrl").

main() ->
    hhs_common:check_role(user).

title() -> "Main".

header() ->
    hhs_common:header(main).

content() ->
    #panel{
        body = [
            #panel{class = row, body = #panel{class = "column column-100", body = p1()}}
        ]
    }.

p1() ->
    #p{body = "HHS"}.
