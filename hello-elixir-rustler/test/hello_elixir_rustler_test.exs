defmodule HelloElixirRustlerTest do
  use ExUnit.Case
  doctest HelloElixirRustler

  test "greets the world" do
    assert HelloElixirRustler.hello() == :world
  end

  test "nif works" do
    assert HelloElixirRustler.RustlerNif.add(40, 2) == 42
  end
end
