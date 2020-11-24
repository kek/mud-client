defmodule Mud.Game do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Supervisor
  require Logger

  def init(init_args) do
    Logger.info("Starting Mud.Game")
    {:ok, init_args}
  end

  def start_link(_options) do
    port = System.fetch_env!("PORT")
    host = System.fetch_env!("HOST")

    children =
      if System.get_env("START_GAME") do
        [
          {Mud.Terminal, [name: Mud.Terminal]},
          {Mud.Connection, [port: port, host: host, name: Mud.Connection]}
        ]
      else
        []
      end

    opts = [strategy: :one_for_one, name: Mud.Game]
    Supervisor.start_link(children, opts)
  end
end
