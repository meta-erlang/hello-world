hello-erlang-interoperability
=====

This code is just putting the example from the oficial Erlang documentation about
[Port Drivers](https://erlang.org/doc/tutorial/c_portdriver.html) and wrapping it with
rebar3 and a [Makefile](c_src/Makefile) that gets the include and static library need
using pkg-config or asking the path to Erlang VM.