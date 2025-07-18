defmodule ApiFrameworkElixir.Models.Responses.ErrorResponse do
  @moduledoc """
  Error response model struct.
  This replaces the TypeScript ErrorResponse interface.
  """

  @type t :: %__MODULE__{
          status: String.t(),
          message: String.t() | nil,
          errors: [String.t()]
        }

  defstruct [
    :status,
    :message,
    :errors
  ]

  @doc """
  Creates a new error response struct from a map.
  """
  def new(attrs \\ %{}) do
    struct(__MODULE__, %{
      status: attrs["status"],
      message: attrs["message"],
      errors: attrs["errors"] || []
    })
  end
end
