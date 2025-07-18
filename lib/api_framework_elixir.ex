defmodule ApiFrameworkElixir do
  @moduledoc """
  API Framework for Elixir - A comprehensive testing framework for REST APIs.
  
  This framework provides a simple but effective way to test REST APIs with
  built-in authentication, session management, and comprehensive test utilities.
  """

  @doc """
  Starts the application and loads environment variables.
  """
  def start(_type, _args) do
    # Load environment variables
    Dotenvy.source([".env", ".env.local", ".env.#{Mix.env()}"], env: Mix.env())
    
    children = []
    opts = [strategy: :one_for_one, name: ApiFrameworkElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end
end 