defmodule ApiFrameworkElixir.Models.Credentials do
  @moduledoc """
  Credentials model struct for authentication.
  This replaces the TypeScript CredentialsModel interface.
  """

  @type t :: %__MODULE__{
    username: String.t() | nil,
    password: String.t() | nil
  }

  defstruct [
    :username,
    :password
  ]

  @doc """
  Creates a new credentials struct from a map.
  """
  def new(attrs \\ %{}) do
    struct(__MODULE__, attrs)
  end

  @doc """
  Converts the credentials struct to a map for JSON serialization.
  """
  def to_map(%__MODULE__{} = credentials) do
    credentials
    |> Map.from_struct()
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
  end
end
