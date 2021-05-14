hello-elixir-interoperability
=====

This code is just using the example from the oficial Erlang documentation about
[Port Drivers](https://erlang.org/doc/tutorial/c_portdriver.html) and wrapping it with
Elixir mix building tool, plus a [Makefile](Makefile), that gets the include and static library need
using pkg-config or asking the path to Erlang VM.