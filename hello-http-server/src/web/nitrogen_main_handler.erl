-module(nitrogen_main_handler).
-export([
    run/0,
    ws_init/0
]).

handlers() ->
    nitrogen:handler(debug_crash_handler, []),
    nitrogen:handler(hhs_config_handler, []),
    nitrogen:handler(hhs_security_handler, []),
    ok.

ws_init() ->
    handlers().

run() ->
    handlers(),
    nitrogen:run().
