defmodule HelloElixirRustler.MixProject do
  use Mix.Project

  def project do
    [
      app: :hello_elixir_rustler,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        hello_elixir_rustler: [
          applications: [
            hello_elixir_rustler: :permanent
          ],
          steps: [
            :assemble,
            :tar
          ],
          # MIX_TARGET_INCLUDE_ERTS is set by meta-erlang/classes/mix.bbclass
          include_erts: System.get_env("MIX_TARGET_INCLUDE_ERTS") || false
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rustler, "~> 0.25.0"}
    ]
  end
end
