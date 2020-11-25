defmodule Mud.Connection do
  use GenServer
  require Logger

  def init(%{host: host, port: port}) do
    Logger.debug("Starting Mud.Connection")
    host = String.to_charlist(host)
    port = String.to_integer(port)
    {:ok, socket} = :gen_tcp.connect(host, port, [])

    {:ok, %{socket: socket}}
  end

  def start_link(options) do
    port = Keyword.get(options, :port)
    host = Keyword.get(options, :host)
    GenServer.start_link(__MODULE__, %{host: host, port: port}, options)
  end

  def send(me, text) do
    GenServer.call(me, {:send, text})
  end

  def handle_call({:send, text}, _from, state) do
    # Logger.debug("Sending #{text}")
    :gen_tcp.send(state.socket, "#{text}\n")
    {:reply, :ok, state}
  end

  def handle_info({:tcp_closed, socket}, state) do
    Logger.debug("tcp_closed #{inspect(socket)} (#{inspect(state)})")
    {:noreply, state}
  end

  def handle_info({:tcp, _socket, text}, state) do
    text = List.to_string(text)
    Mud.Terminal.print(text)
    {:noreply, state}
  end
end
