defmodule ApiFrameworkElixir.ServiceBase do
  @moduledoc """
  Base service module that provides common HTTP methods and authentication.
  This module replaces the TypeScript ServiceBase functionality.
  """

  alias ApiFrameworkElixir.{HTTPClient, SessionManager}

  @doc """
  Gets the base URL from configuration.
  """
  def base_url do
    Application.get_env(:api_framework_elixir, :base_url) ||
      System.get_env("BASEURL") ||
      "http://192.168.1.8:3001"
  end

  @doc """
  Authenticates the service using environment credentials.
  """
  def authenticate do
    username = Application.get_env(:api_framework_elixir, :username) || System.get_env("API_USER")

    password =
      Application.get_env(:api_framework_elixir, :password) || System.get_env("API_PASSWORD")

    if is_nil(username) or is_nil(password) do
      raise "Missing username or password in environment variables."
    end

    cached_token = SessionManager.get_cached_token(username, password)

    if cached_token do
      [{"Cookie", "token=#{cached_token}"}]
    else
      credentials = %{username: username, password: password}
      response = post("#{base_url()}/auth", credentials)

      case response do
        {:ok, %{data: %{"token" => token}, status: 200}} ->
          SessionManager.store_token(username, password, token)
          [{"Cookie", "token=#{token}"}]

        {:error, reason} ->
          raise "Authentication failed: #{inspect(reason)}"

        _ ->
          raise "Authentication failed with unexpected response"
      end
    end
  end

  @doc """
  Makes a GET request with timing and response formatting.
  """
  def get(url, headers \\ [], params \\ []) do
    start_time = System.monotonic_time(:millisecond)

    case HTTPClient.get(url, headers, params) do
      {:ok, response} ->
        end_time = System.monotonic_time(:millisecond)
        response_time = end_time - start_time

        parsed_response = HTTPClient.parse_json_response({:ok, response})
        {:ok, Map.put(elem(parsed_response, 1), :response_time, response_time)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Makes a POST request with timing and response formatting.
  """
  def post(url, data, headers \\ []) do
    start_time = System.monotonic_time(:millisecond)
    # Add User-Agent header to match curl
    headers = [{"Content-Type", "application/json"}, {"User-Agent", "curl/7.64.1"}] ++ headers

    case HTTPClient.post(url, data, headers) do
      {:ok, response} ->
        end_time = System.monotonic_time(:millisecond)
        response_time = end_time - start_time

        parsed_response = HTTPClient.parse_json_response({:ok, response})
        {:ok, Map.put(elem(parsed_response, 1), :response_time, response_time)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Makes a PUT request with timing and response formatting.
  """
  def put(url, data, headers \\ []) do
    start_time = System.monotonic_time(:millisecond)

    case HTTPClient.put(url, data, headers) do
      {:ok, response} ->
        end_time = System.monotonic_time(:millisecond)
        response_time = end_time - start_time

        parsed_response = HTTPClient.parse_json_response({:ok, response})
        {:ok, Map.put(elem(parsed_response, 1), :response_time, response_time)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Makes a PATCH request with timing and response formatting.
  """
  def patch(url, data, headers \\ []) do
    start_time = System.monotonic_time(:millisecond)

    case HTTPClient.patch(url, data, headers) do
      {:ok, response} ->
        end_time = System.monotonic_time(:millisecond)
        response_time = end_time - start_time

        parsed_response = HTTPClient.parse_json_response({:ok, response})
        {:ok, Map.put(elem(parsed_response, 1), :response_time, response_time)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Makes a DELETE request with timing and response formatting.
  """
  def delete(url, headers \\ []) do
    start_time = System.monotonic_time(:millisecond)

    case HTTPClient.delete(url, headers) do
      {:ok, response} ->
        end_time = System.monotonic_time(:millisecond)
        response_time = end_time - start_time

        parsed_response = HTTPClient.parse_json_response({:ok, response})
        {:ok, Map.put(elem(parsed_response, 1), :response_time, response_time)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Makes a HEAD request with timing and response formatting.
  """
  def head(url, headers \\ []) do
    start_time = System.monotonic_time(:millisecond)

    case HTTPClient.head(url, headers) do
      {:ok, response} ->
        end_time = System.monotonic_time(:millisecond)
        response_time = end_time - start_time

        {:ok,
         %{
           data: response.body,
           status: response.status_code,
           headers: response.headers,
           response_time: response_time
         }}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Makes an OPTIONS request with timing and response formatting.
  """
  def options(url, headers \\ []) do
    start_time = System.monotonic_time(:millisecond)

    case HTTPClient.options(url, headers) do
      {:ok, response} ->
        end_time = System.monotonic_time(:millisecond)
        response_time = end_time - start_time

        parsed_response = HTTPClient.parse_json_response({:ok, response})
        {:ok, Map.put(elem(parsed_response, 1), :response_time, response_time)}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
