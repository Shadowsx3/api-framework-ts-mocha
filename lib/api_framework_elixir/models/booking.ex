defmodule ApiFrameworkElixir.Models.Booking do
  @moduledoc """
  Booking model struct that represents a booking entity.
  This replaces the TypeScript BookingModel interface.
  """

  @type t :: %__MODULE__{
    id: integer() | nil,
    firstname: String.t() | nil,
    lastname: String.t() | nil,
    totalprice: number() | nil,
    depositpaid: boolean() | nil,
    bookingdates: %{
      checkin: String.t() | nil,
      checkout: String.t() | nil
    } | nil,
    additionalneeds: String.t() | nil
  }

  defstruct [
    :id,
    :firstname,
    :lastname,
    :totalprice,
    :depositpaid,
    :bookingdates,
    :additionalneeds
  ]

  @doc """
  Creates a new booking struct from a map.
  """
  def new(attrs \\ %{}) do
    struct(__MODULE__, attrs)
  end

  @doc """
  Converts the booking struct to a map for JSON serialization.
  """
  def to_map(%__MODULE__{} = booking) do
    booking
    |> Map.from_struct()
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
  end
end 