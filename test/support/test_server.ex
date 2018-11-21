defmodule Mud.TestServer do
  defmodule Conversation do
    def start(socket) do
      spawn(fn ->
        IO.puts("started new conversation at #{inspect(self())}")
        converse(socket)
      end)
    end

    def converse(socket) do
      receive do
        {:tcp, port, 'quit\r\n'} ->
          IO.puts("quitting #{inspect(port)}")
          :gen_tcp.send(socket, "done")

        {:tcp, port, text} ->
          IO.puts("#{inspect(port)} #{text}")
          :gen_tcp.send(socket, "yes, #{text}")
          converse(socket)

        {:tcp_closed, port} ->
          IO.puts("Closed #{inspect(port)}")

        message ->
          IO.puts("unexpected message: #{message}")
      end
    end
  end

  def start(port) do
    {:ok, listening_socket} = :gen_tcp.listen(port, [])
    IO.puts("listening #{inspect(listening_socket)}")

    listen(listening_socket)
  end

  defp listen(listening_socket) do
    {:ok, socket} = :gen_tcp.accept(listening_socket)
    IO.puts("connected #{inspect(socket)}")

    conversation = Conversation.start(socket)
    :ok = :gen_tcp.controlling_process(socket, conversation)
    IO.puts("handed over to #{inspect(conversation)}")

    listen(listening_socket)
  end
end
