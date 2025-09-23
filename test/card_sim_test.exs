defmodule CardSimTest do
  use ExUnit.Case
  doctest CardSim

  test "greets the world" do
    assert CardSim.hello() == :world
  end
end
