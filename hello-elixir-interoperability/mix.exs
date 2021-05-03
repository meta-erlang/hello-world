defmodule HelloElixirInteroperability.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/meta-erlang/hello-world"

  def project do
    [
      app: :hello_elixir_interoperability,
      version: @version,
      description: description(),
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:elixir_make] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      package: package(),
      releases: [
        hello_elixir_interoperability: [
          applications: [
            hello_elixir_interoperability: :permanent
          ],
          steps: [
            :assemble,
            :tar
          ],
          # MIX_TARGET_INCLUDE_ERTS is set by meta-erlang/classes/mix.bbclass
          include_erts: System.get_env("MIX_TARGET_INCLUDE_ERTS")
        ]
      ],
      source_url: @source_url,
      homepage_url: "https://github.com/meta-erlang/hello-world",
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {HelloElixirInteroperability.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:elixir_make, "~> 0.6", runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    []
  end

  defp description() do
    "A simple example showing how to build Elixir project in YP/OE."
  end

  defp package do
    [
      files: ["lib", "LICENSE", "mix.exs", "README.md", "src/*.[ch]", "Makefile"],
      licenses: ["MIT"],
      links: %{"Github" => @source_url}
    ]
  end
end
