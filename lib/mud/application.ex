defmodule Mud.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children =
      if System.get_env("START_GAME") do
        [
          {Mud.Game, []}
        ]
      else
        []
      end

    opts = [strategy: :one_for_one, name: Mud.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
