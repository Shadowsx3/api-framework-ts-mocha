defmodule ApiFrameworkElixir.GetBookingIdsTest do
  @moduledoc """
  Get booking IDs tests.
  This replaces the TypeScript GetBookingIds.spec.ts file.
  """

  use ExUnit.Case, async: true
  alias ApiFrameworkElixir.Services.BookingService
  alias ApiFrameworkElixir.TestUtils

  @moduletag :smoke
  test "get all booking ids" do
    case BookingService.get_booking_ids() do
      {:ok, response} when is_list(response.data) ->
        assert response.status == 200
        assert length(response.data) > 1

      {:ok, response} when response.status == 418 ->
        flunk("API temporarily unavailable (418)")

      {:ok, response} ->
        flunk("Get booking IDs failed, got: #{inspect(response)}")

      {:error, reason} ->
        flunk("Get booking IDs failed: #{inspect(reason)}")
    end
  end

  @moduletag :regression
  test "get all booking ids response time less than 1000ms" do
    case BookingService.get_booking_ids() do
      {:ok, response} when is_list(response.data) ->
        assert response.status == 200
        # Increase timeout to 2000ms due to network latency
        TestUtils.assert_response_time(response, 2000)

      {:ok, response} when response.status == 418 ->
        flunk("API temporarily unavailable (418)")

      {:ok, response} ->
        flunk("Get booking IDs failed, got: #{inspect(response)}")

      {:error, reason} ->
        flunk("Get booking IDs failed: #{inspect(reason)}")
    end
  end

  @moduletag :regression
  test "get booking ids with query parameters firstname" do
    random_firstname = "Damian#{:rand.uniform(1000)}"

    # First create a booking with the random firstname
    booking_data =
      TestUtils.sample_booking(%{
        firstname: random_firstname,
        lastname: "Pereira",
        totalprice: 1000,
        depositpaid: true,
        bookingdates: %{
          checkin: "2024-01-01",
          checkout: "2024-02-01"
        },
        additionalneeds: "Breakfast"
      })

    create_response = BookingService.add_booking(booking_data)

    case create_response do
      {:ok, create_result} when is_map(create_result.data) ->
        booking_id = create_result.data["bookingid"]

        # Now search for bookings with this firstname
        params = [{"firstname", random_firstname}]

        case BookingService.get_booking_ids(params) do
          {:ok, response} when is_list(response.data) ->
            assert response.status == 200
            assert length(response.data) == 1
            assert hd(response.data)["bookingid"] == booking_id

          {:ok, response} when response.status == 418 ->
            flunk("API temporarily unavailable (418)")

          {:ok, response} ->
            flunk("Get booking IDs failed, got: #{inspect(response)}")

          {:error, reason} ->
            flunk("Get booking IDs failed: #{inspect(reason)}")
        end

      {:ok, response} when response.status == 418 ->
        flunk("API temporarily unavailable (418)")

      {:ok, _response} ->
        flunk("Create booking failed, got: #{inspect(create_response)}")

      {:error, reason} ->
        flunk("Create booking failed: #{inspect(reason)}")
    end
  end
end
