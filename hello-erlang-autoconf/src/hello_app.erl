-module(hello_app).

-behaviour(application).

-export([start/2, stop/1]).

start(normal, _) -> hello_sup:start_link().

stop([]) -> ok.
