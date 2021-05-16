-module(web_404).
-compile(export_all).
-include("hhs.hrl").

main() ->
    wf:status_code(404),
    #template{file = code:priv_dir(hello_http_server) ++ "/templates/base.html"}.

title() -> "Page Not Found".

content() ->
    [
        #h1{text = "Page Not Found"},
        #p{class = "notification", body = "The page you requested does not exist."}
    ].
