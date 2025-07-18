defmodule ApiFrameworkElixir.Services.BookingService do
  @moduledoc """
  Booking service for handling booking operations.
  This replaces the TypeScript BookingService functionality.
  """

  alias ApiFrameworkElixir.{ServiceBase, Models.Booking}

  @base_path "/booking"

  @doc """
  Gets all booking IDs with optional query parameters.
  """
  def get_booking_ids(params \\ []) do
    url = "#{ServiceBase.base_url()}#{@base_path}"
    ServiceBase.get(url, [], params)
  end

  @doc """
  Gets a specific booking by ID.
  """
  def get_booking(id) do
    url = "#{ServiceBase.base_url()}#{@base_path}/#{id}"
    ServiceBase.get(url)
  end

  @doc """
  Adds a new booking.
  """
  def add_booking(%Booking{} = booking) do
    url = "#{ServiceBase.base_url()}#{@base_path}"
    headers = [{"Content-Type", "application/json"}]
    ServiceBase.post(url, Booking.to_map(booking), headers)
  end

  def add_booking(booking_attrs) when is_map(booking_attrs) do
    booking = Booking.new(booking_attrs)
    add_booking(booking)
  end

  @doc """
  Updates a booking completely.
  """
  def update_booking(id, booking, headers \\ [])

  def update_booking(id, %Booking{} = booking, headers) do
    url = "#{ServiceBase.base_url()}#{@base_path}/#{id}"
    ServiceBase.put(url, Booking.to_map(booking), headers)
  end

  def update_booking(id, booking_attrs, headers) when is_map(booking_attrs) do
    booking = Booking.new(booking_attrs)
    update_booking(id, booking, headers)
  end

  @doc """
  Partially updates a booking.
  """
  def partial_update_booking(id, booking, headers \\ [])

  def partial_update_booking(id, %Booking{} = booking, headers) do
    url = "#{ServiceBase.base_url()}#{@base_path}/#{id}"
    ServiceBase.patch(url, Booking.to_map(booking), headers)
  end

  def partial_update_booking(id, booking_attrs, headers) when is_map(booking_attrs) do
    booking = Booking.new(booking_attrs)
    partial_update_booking(id, booking, headers)
  end

  @doc """
  Deletes a booking.
  """
  def delete_booking(id, headers \\ []) do
    url = "#{ServiceBase.base_url()}#{@base_path}/#{id}"
    ServiceBase.delete(url, headers)
  end

  @doc """
  Authenticates the booking service.
  """
  def authenticate do
    ServiceBase.authenticate()
  end
end
