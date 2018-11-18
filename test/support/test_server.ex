defmodule Mud.TestServer do
  use GenServer

  def init(args) do
    {:ok, args}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end
end
