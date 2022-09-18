defmodule HelloElixirRustler.RustlerNif do
  use Rustler,
    otp_app: :hello_elixir_rustler,
    crate: "helloelixirrustler_rustlernif",
    target: System.get_env("RUST_TARGET")

  # When your NIF is loaded, it will override this function.
  def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)
end
