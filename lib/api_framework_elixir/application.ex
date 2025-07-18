defmodule ApiFrameworkElixir.Application do
  @moduledoc """
  The ApiFrameworkElixir Application.
  """

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ApiFrameworkElixir.SessionManager
    ]

    opts = [strategy: :one_for_one, name: ApiFrameworkElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
