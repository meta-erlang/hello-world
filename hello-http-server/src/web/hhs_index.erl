-module(hhs_index).
-compile(export_all).
-include("hhs.hrl").

main() ->
    #template{file = code:priv_dir(hello_http_server) ++ "/templates/base.html"}.

title() -> "Index".

header() ->
    hhs_common:header(index).

content() ->
    #panel{
        body = [
            #panel{class = row, body = #panel{class = "column column-100", body = p1()}}
        ]
    }.

p1() ->
    #p{
        body =
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
    }.
