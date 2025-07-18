defmodule ApiFrameworkElixir.Models.Responses.BookingIdResponse do
  @moduledoc """
  Booking ID response model struct.
  This replaces the TypeScript BookingIdResponse interface.
  """

  @type t :: %__MODULE__{
    bookingid: integer()
  }

  defstruct [
    :bookingid
  ]

  @doc """
  Creates a new booking ID response struct from a map.
  """
  def new(attrs \\ %{}) do
    struct(__MODULE__, %{
      bookingid: attrs["bookingid"]
    })
  end
end
