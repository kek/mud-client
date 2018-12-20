defmodule TestServer do
  def init(port) do
    {:ok, listening_socket} = :gen_tcp.listen(port, [])
    IO.puts("listening #{inspect(listening_socket)}")

    {:ok, [], {:continue, listening_socket}}
  end

  def handle_continue(listening_socket, state) do
    {:ok, socket} = :gen_tcp.accept(listening_socket)
    IO.puts("connected #{inspect(socket)}")
    :ok = :gen_tcp.controlling_process(socket, Conversation.start_link())

    {:noreply, state, {:continue, listening_socket}}
  end

  def start_link(port) do
    GenServer.start_link(__MODULE__, port, name: __MODULE__)
  end
end
