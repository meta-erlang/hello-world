-module(hhs_system).
-compile(export_all).
-include("hhs.hrl").

main() ->
    hhs_common:check_role(user).

title() -> "About".

header() ->
    hhs_common:header(system).

content() ->
    #panel{
        body = [
            #panel{class = row, body = #panel{class = "column column-100", body = about()}}
        ]
    }.

about() ->
    [
        #h2{text = "System Overview"},
        #p{body = "TBD"}
    ].
