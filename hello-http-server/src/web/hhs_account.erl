-module(hhs_account).
-compile(export_all).
-include("hhs.hrl").

main() ->
    hhs_common:check_role(user).

title() -> "About".

header() ->
    hhs_common:header(acount).

content() ->
    #panel{
        body = [
            #panel{class = row, body = #panel{class = "column column-100", body = acount()}}
        ]
    }.

acount() ->
    [
        #h2{text = "Acount"},
        #p{body = "TBD"}
    ].
