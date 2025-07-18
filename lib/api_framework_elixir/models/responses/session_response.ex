defmodule ApiFrameworkElixir.Models.Responses.SessionResponse do
  @moduledoc """
  Session response model struct.
  This replaces the TypeScript SessionResponse interface.
  """

  @type t :: %__MODULE__{
    token: String.t()
  }

  defstruct [
    :token
  ]

  @doc """
  Creates a new session response struct from a map.
  """
  def new(attrs \\ %{}) do
    struct(__MODULE__, %{
      token: attrs["token"]
    })
  end
end
