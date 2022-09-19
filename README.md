# hello-world Erlang and Elixir examples for meta-erlang

This repository offers a set of minimal working applications demonstrating how that
is possible to integrate Erlang and Elixir application with [meta-erlang](https://github.com/meta-erlang/meta-erlang)
for Yocto Project/Openembedded.

Summary of examples:

* Erlang
  * [hello-http-server](hello-http-server): A minimal http server written in Nitrogen. [hello-http-server_0.1.0.bb](https://github.com/meta-erlang/meta-erlang/tree/master/recipes-examples/hello-http-server/hello-http-server_0.1.0.bb)
  * [hello-rabbitmq](hello-rabbitmq): A minimal client that sends heart beats to a rabbitmq server. [hello-rabbitmq_0.1.0.bb](https://github.com/meta-erlang/meta-erlang/tree/master/recipes-examples/hello-rabbitmq/hello-rabbitmq_0.1.0.bb)
  * [hello-erlang-interoperability](hello-erlang-interoperability): A minimal Erlang application with Erlang port driver written in C. [hello-erlang-interoperability_0.1.0.bb](https://github.com/meta-erlang/meta-erlang/tree/master/recipes-examples/hello-erlang-interoperability/hello-erlang-interoperability_0.1.0.bb)
  * [hello-erlang-c-node](hello-erlang-c-node): A minimal Erlang C Node. [hello-erlang-c-node_0.1.0.bb](https://github.com/meta-erlang/meta-erlang/tree/master/recipes-examples/hello-erlang-interoperability/hello-erlang-c-node_0.1.0.bb)

* Elixir
  * [hello-phoenix](hello-phoenix): A minimal phoenix server. [hello-phoenix_0.1.0.bb](https://github.com/meta-erlang/meta-erlang/tree/master/recipes-examples/hello-phoenix/hello-phoenix_0.1.0.bb)
  * [hello-elixir-interoperability](hello-elixir-interoperability): A minimal Elixir application with Erlang NIF written in C. [hello-elixir-interoperability_0.1.0.bb](https://github.com/meta-erlang/meta-erlang/tree/master/recipes-examples/hello-elixir-interoperability/hello-elixir-interoperability_0.1.0.bb)
  * [hello-elixir-rustler](hello-elixir-rustler): A [rustler](https://github.com/rusterlium/rustler) getting started application. 

For more resources about meta-erlang, check out the [meta-erlang documentation](https://meta-erlang.github.io/#/). [hello-elixir-rustler_0.1.0.bb](https://github.com/meta-erlang/meta-erlang/tree/master/recipes-examples/hello-elixir-rustler/hello-elixir-rustler_0.1.0.bb)