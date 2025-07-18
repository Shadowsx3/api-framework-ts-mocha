defmodule ApiFrameworkElixir.AuthTest do
  @moduledoc """
  Authentication tests.
  This replaces the TypeScript auth.spec.ts file.
  """

  use ExUnit.Case, async: true
  alias ApiFrameworkElixir.Services.AuthService
  alias ApiFrameworkElixir.TestUtils
  alias ApiFrameworkElixir.Models.Credentials

  @moduletag :smoke
  test "sign in with valid credentials" do
    credentials = TestUtils.sample_credentials() |> Credentials.new()

    case AuthService.sign_in(credentials) do
      {:ok, response} when is_map(response.data) ->
        assert response.status == 200
        assert is_binary(response.data["token"])

      {:ok, response} when response.status == 418 ->
        flunk("API temporarily unavailable (418)")

      {:ok, response} ->
        flunk("Sign in failed, got: #{inspect(response)}")

      {:error, reason} ->
        flunk("Sign in failed: #{inspect(reason)}")
    end
  end

  @moduletag :regression
  test "sign in with wrong username" do
    credentials = %{username: "wrong_username", password: "pass"} |> Credentials.new()

    case AuthService.sign_in(credentials) do
      {:ok, response} when is_map(response.data) ->
        assert response.status == 200
        assert response.data["reason"] == "Bad credentials"

      {:ok, response} when response.status == 418 ->
        flunk("API temporarily unavailable (418)")

      {:ok, response} ->
        flunk("Sign in failed, got: #{inspect(response)}")

      {:error, reason} ->
        flunk("Sign in failed: #{inspect(reason)}")
    end
  end

  @moduletag :regression
  test "sign in with wrong password" do
    credentials = %{username: "admin", password: "wrong_password"} |> Credentials.new()

    case AuthService.sign_in(credentials) do
      {:ok, response} when is_map(response.data) ->
        assert response.status == 200
        assert response.data["reason"] == "Bad credentials"

      {:ok, response} when response.status == 418 ->
        flunk("API temporarily unavailable (418)")

      {:ok, response} ->
        flunk("Sign in failed, got: #{inspect(response)}")

      {:error, reason} ->
        flunk("Sign in failed: #{inspect(reason)}")
    end
  end
end
