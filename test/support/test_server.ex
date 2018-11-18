defmodule Mud.TestServer do
  use GenServer

  def init([port]) do
    {:ok, socket} = :gen_tcp.listen(port, [])
    IO.inspect(socket)
    {:ok, socket} = :gen_tcp.accept(socket)
    IO.inspect(socket)

    {:ok, %{socket: socket}}
  end

  def start_link() do
    start_link(5000)
  end

  def start_link(port) do
    GenServer.start_link(__MODULE__, [port])
  end

  def handle_info({:tcp, _port, text}, state) do
    IO.puts("Got #{text}")
    {:noreply, state}
  end

  def handle_info({:tcp_closed, _port}, state) do
    IO.puts("Closed")
    {:noreply, state}
  end
end
