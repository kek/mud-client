defmodule Mud.Terminal do
  use GenServer
  require Logger

  def init(init_arg) do
    Logger.debug("Starting Mud.Terminal")

    loop()
    {:ok, init_arg}
  end

  def start_link(options) do
    IO.puts("starting temrinal")

    Application.ensure_all_started(:remix)
    GenServer.start_link(__MODULE__, [], options)
  end

  def handle_cast({:loop}, state) do
    command = IO.gets("> ") |> String.trim()
    do_command(command)

    loop()
    {:noreply, state}
  end

  def print(text) do
    IO.puts(text)
  end

  defp loop(), do: GenServer.cast(self(), {:loop})

  defp do_command("observer") do
    Logger.info("Start observer")
    spawn(&:observer.start/0)
  end

  defp do_command("") do
  end

  defp do_command(text) do
    Mud.Connection.send(Mud.Connection, text)
  end
end
