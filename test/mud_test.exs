defmodule MudTest do
  use ExUnit.Case
  doctest Mud

  test "greets the world" do
    Mud.TestServer.start_link()
  end
end
