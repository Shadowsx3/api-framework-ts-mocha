defmodule ApiFrameworkElixir.TestUtils do
  @moduledoc """
  Test utilities for common testing operations.
  """

  import ExUnit.Assertions

  @doc """
  Creates a sample booking map for testing.
  """
  def sample_booking(attrs \\ %{}) do
    %{
      firstname: attrs[:firstname] || "John",
      lastname: attrs[:lastname] || "Doe",
      totalprice: attrs[:totalprice] || 100,
      depositpaid: attrs[:depositpaid] || true,
      bookingdates: %{
        checkin: attrs[:checkin] || "2024-01-01",
        checkout: attrs[:checkout] || "2024-01-02"
      },
      additionalneeds: attrs[:additionalneeds] || "Breakfast"
    }
  end

  @doc """
  Creates sample credentials for testing.
  """
  def sample_credentials(attrs \\ %{}) do
    %{
      username: attrs[:username] || "admin",
      password: attrs[:password] || "password123"
    }
  end

  @doc """
  Asserts that a response has a specific status code.
  """
  def assert_status(response, expected_status) do
    assert response.status == expected_status
  end

  @doc """
  Asserts that a response time is less than a threshold.
  """
  def assert_response_time(response, max_time_ms) do
    assert response.response_time < max_time_ms
  end

  @doc """
  Asserts that a booking has the expected attributes.
  """
  def assert_booking_attributes(booking, expected_attrs) do
    Enum.each(expected_attrs, fn {key, value} ->
      assert Map.get(booking, key) == value
    end)
  end
end
