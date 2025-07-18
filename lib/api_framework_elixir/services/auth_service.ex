defmodule ApiFrameworkElixir.Services.AuthService do
  @moduledoc """
  Authentication service for handling sign-in operations.
  This replaces the TypeScript AuthService functionality.
  """

  alias ApiFrameworkElixir.{ServiceBase, Models.Credentials}

  @doc """
  Signs in with the provided credentials.
  """
  def sign_in(%Credentials{} = credentials) do
    headers = [{"Content-Type", "application/json"}]
    ServiceBase.post("#{ServiceBase.base_url()}/auth", Credentials.to_map(credentials), headers)
  end

  @doc """
  Signs in with username and password strings.
  """
  def sign_in(username, password) do
    credentials = Credentials.new(%{username: username, password: password})
    sign_in(credentials)
  end
end
