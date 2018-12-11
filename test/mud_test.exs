defmodule MudTest do
  use ExUnit.Case
  doctest Mud

  test "greets the world" do
    Mud.TestServer.start_link(5001)
    {:ok, socket} = :gen_tcp.connect('localhost', 5001, [])
    IO.inspect(socket, label: "socket")
    :ok = :gen_tcp.send(socket, 'BU!\r\n')
  end
end
