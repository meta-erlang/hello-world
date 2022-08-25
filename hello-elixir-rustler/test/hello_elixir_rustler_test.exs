defmodule HelloElixirRustlerTest do
  use ExUnit.Case
  doctest HelloElixirRustler

  test "greets the world" do
    assert HelloElixirRustler.hello() == :world
  end
end
