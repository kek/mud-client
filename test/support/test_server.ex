defmodule Mud.TestServer do
  alias Mud.TestConversation

  require Logger

  defmodule State do
    defstruct nothing: nil
  end

  def init(port) do
    {:ok, listening_socket} = :gen_tcp.listen(port, [])
    IO.puts("listening #{inspect(listening_socket)}")

    {:ok, %State{}, {:continue, listening_socket}}
  end

  def handle_continue(listening_socket, state = %State{}) do
    {:ok, socket} = :gen_tcp.accept(listening_socket)
    IO.puts("connected #{inspect(socket)}")

    case :gen_tcp.controlling_process(socket, TestConversation.start_link()) do
      :ok -> true
      {:error, :closed} -> Logger.error("Socket closed")
    end

    {:noreply, state, {:continue, listening_socket}}
  end

  def start_link(port) do
    GenServer.start_link(__MODULE__, port, name: __MODULE__)
  end
end
