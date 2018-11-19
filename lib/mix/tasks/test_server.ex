defmodule Mix.Tasks.TestServer do
  use Mix.Task

  @shortdoc "Run the test server"

  def run([]) do
    run([5000])
  end

  def run([port]) when is_binary(port) do
    run([String.to_integer(port)])
  end

  def run([port]) do
    IO.puts("Running test server")
    Mud.TestServer.start(port)
    IO.gets(:stdio, "Enter to quit: ")
  end
end
