defmodule Mud.TestConversation do
  use GenServer

  def init(args) do
    {:ok, args}
  end

  def start_link do
    {:ok, pid} = GenServer.start_link(__MODULE__, [])
    pid
  end

  def handle_info({:tcp, port, text}, state) do
    IO.puts("#{inspect(port)} #{text}")
    :gen_tcp.send(port, String.reverse(text))
    {:noreply, state}
  end

  def handle_info({:tcp_closed, port}, state) do
    IO.puts("Closed #{inspect(port)}")
    {:stop, :normal, state}
  end
end
