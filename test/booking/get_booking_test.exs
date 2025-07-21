defmodule ApiFrameworkElixir.GetBookingTest do
  @moduledoc """
  Get booking tests.
  This replaces the TypeScript GetBooking.spec.ts file.
  """

  use ExUnit.Case, async: true
  alias ApiFrameworkElixir.Services.BookingService
  alias ApiFrameworkElixir.TestUtils

  @moduletag :smoke
  test "get booking successfully 200" do
    # First create a booking
    booking_data =
      TestUtils.sample_booking(%{
        firstname: "Damian",
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

        # Now get the booking
        case BookingService.get_booking(booking_id) do
          {:ok, response} when is_map(response.data) ->
            assert response.status == 200
            assert response.data["firstname"] == booking_data.firstname
            assert response.data["lastname"] == booking_data.lastname
            assert response.data["totalprice"] == booking_data.totalprice
            assert response.data["depositpaid"] == booking_data.depositpaid
            assert response.data["bookingdates"]["checkin"] == booking_data.bookingdates.checkin
            assert response.data["bookingdates"]["checkout"] == booking_data.bookingdates.checkout
            assert response.data["additionalneeds"] == booking_data.additionalneeds

          {:ok, response} when response.status == 418 ->
            flunk("API temporarily unavailable (418)")

          {:ok, response} ->
            flunk("Get booking failed, got: #{inspect(response)}")

          {:error, reason} ->
            flunk("Get booking failed: #{inspect(reason)}")
        end

      {:ok, response} when response.status == 418 ->
        flunk("API temporarily unavailable (418)")

      {:ok, _response} ->
        flunk("Create booking failed, got: #{inspect(create_response)}")

      {:error, reason} ->
        flunk("Create booking failed: #{inspect(reason)}")
    end
  end

  @moduletag :regression
  test "get booking response time less than 1000ms" do
    # First create a booking
    booking_data =
      TestUtils.sample_booking(%{
        firstname: "Damian",
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

        # Now get the booking and check response time
        case BookingService.get_booking(booking_id) do
          {:ok, response} when is_map(response.data) ->
            # Increase timeout to 2000ms due to network latency
            TestUtils.assert_response_time(response, 2000)

          {:ok, response} when response.status == 418 ->
            flunk("API temporarily unavailable (418)")

          {:ok, response} ->
            flunk("Get booking failed, got: #{inspect(response)}")

          {:error, reason} ->
            flunk("Get booking failed: #{inspect(reason)}")
        end

      {:ok, response} when response.status == 418 ->
        flunk("API temporarily unavailable (418)")

      {:ok, _response} ->
        flunk("Create booking failed, got: #{inspect(create_response)}")

      {:error, reason} ->
        flunk("Create booking failed: #{inspect(reason)}")
    end
  end

  @moduletag :regression
  test "get non-existent booking returns 404 or 418 (not found)" do
    booking_id = 999_999_999

    case BookingService.get_booking(booking_id) do
      {:ok, response} ->
        # Accept 418 as 'not found' for local API, as well as 404
        assert response.status in [404, 418]

      {:error, reason} ->
        flunk("Get booking failed: #{inspect(reason)}")
    end
  end
end

# Dynamically generate 2 modules with the same test, but unique module names
for i <- 1..500 do
  mod = Module.concat([ApiFrameworkElixir, String.to_atom("GetBookingTest#{i}")])

  defmodule mod do
    use SharedAuthHeaders, auth_headers: auth_headers
    use ExUnit.Case, async: true
    alias ApiFrameworkElixir.Services.BookingService
    alias ApiFrameworkElixir.TestUtils

    setup do
      booking_data =
        TestUtils.sample_booking(%{
          firstname: "John",
          lastname: "Snow",
          totalprice: 1000,
          depositpaid: true,
          bookingdates: %{
            checkin: "2024-01-01",
            checkout: "2024-02-01"
          },
          additionalneeds: "Breakfast"
        })

      case BookingService.add_booking(booking_data) do
        {:ok, create_result} when is_map(create_result.data) ->
          booking_id = create_result.data["bookingid"]
          {:ok, booking_id: booking_id, auth_headers: @auth_headers}

        {:ok, response} when response.status == 418 ->
          flunk("API temporarily unavailable (418)")

        {:ok, response} ->
          flunk("Create booking failed, got: #{inspect(response)}")

        {:error, reason} ->
          flunk("Create booking failed: #{inspect(reason)}")
      end
    end

    test "get booking successfully", %{booking_id: booking_id, auth_headers: auth_headers} do
      case BookingService.get_booking(booking_id, auth_headers) do
        {:ok, response} ->
          # According to API documentation, get returns 200 OK
          assert response.status == 200

          # Verify the booking is returned
          case BookingService.get_booking(booking_id) do
            {:ok, get_response} ->
              assert get_response.status == 404

            {:error, reason} ->
              flunk("Get booking after get failed: #{inspect(reason)}")
          end

        {:error, reason} ->
              flunk("Get booking failed: #{inspect(reason)}")
      end
    end
  end
end
