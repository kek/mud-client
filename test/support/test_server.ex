defmodule Mud.TestServer do
  defmodule Handler do
    use GenServer

    def init(args) do
      {:ok, args}
    end

    def new do
      {:ok, pid} = GenServer.start_link(__MODULE__, [])
      pid
    end

    def handle_info({:tcp, port, text}, state) do
      IO.puts("#{inspect(port)} #{text}")
      {:noreply, state}
    end

    def handle_info({:tcp_closed, port}, state) do
      IO.puts("Closed #{inspect(port)}")
      {:stop, :normal, state}
    end
  end

  def start(port) do
    spawn(fn ->
      {:ok, listening_socket} = :gen_tcp.listen(port, [])
      IO.puts("listening #{inspect(listening_socket)}")
      loop(listening_socket)
    end)
  end

  defp loop(listening_socket) do
    {:ok, socket} = :gen_tcp.accept(listening_socket)
    IO.puts("connected #{inspect(socket)}")
    :ok = :gen_tcp.controlling_process(socket, Handler.new())
    loop(listening_socket)
  end
end
