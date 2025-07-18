defmodule ApiFrameworkElixir.Models.Responses.BookingResponse do
  @moduledoc """
  Booking response model struct.
  This replaces the TypeScript BookingResponse interface.
  """

  alias ApiFrameworkElixir.Models.Booking

  @type t :: %__MODULE__{
    bookingid: integer(),
    booking: Booking.t()
  }

  defstruct [
    :bookingid,
    :booking
  ]

  @doc """
  Creates a new booking response struct from a map.
  """
  def new(attrs \\ %{}) do
    booking = if attrs["booking"] do
      Booking.new(attrs["booking"])
    end

    struct(__MODULE__, %{
      bookingid: attrs["bookingid"],
      booking: booking
    })
  end
end
