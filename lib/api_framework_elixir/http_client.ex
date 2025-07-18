defmodule ApiFrameworkElixir.HTTPClient do
  @moduledoc """
  HTTP client module that provides a wrapper around HTTPoison for making HTTP requests.
  This module replaces the TypeScript ApiClientBase functionality.
  """

  # Proxy options removed

  @default_headers [
    {"Accept", "*/*"},
    {"Content-Type", "application/json"},
    {"User-Agent", "curl/7.64.1"}
  ]

  @doc """
  Makes a GET request to the specified URL with optional headers and query parameters.
  """
  def get(url, headers \\ [], params \\ []) do
    url_with_params = build_url_with_params(url, params)
    headers = @default_headers ++ headers
    HTTPoison.get(url_with_params, headers, [])
  end

  @doc """
  Makes a POST request to the specified URL with data and optional headers.
  """
  def post(url, data, headers \\ []) do
    headers = @default_headers ++ headers
    HTTPoison.post(url, Jason.encode!(data), headers, [])
  end

  @doc """
  Makes a PUT request to the specified URL with data and optional headers.
  """
  def put(url, data, headers \\ []) do
    headers = @default_headers ++ headers
    HTTPoison.put(url, Jason.encode!(data), headers, [])
  end

  @doc """
  Makes a PATCH request to the specified URL with data and optional headers.
  """
  def patch(url, data, headers \\ []) do
    headers = @default_headers ++ headers
    HTTPoison.patch(url, Jason.encode!(data), headers, [])
  end

  @doc """
  Makes a DELETE request to the specified URL with optional headers.
  """
  def delete(url, headers \\ []) do
    headers = @default_headers ++ headers
    HTTPoison.delete(url, headers, [])
  end

  @doc """
  Makes a HEAD request to the specified URL with optional headers.
  """
  def head(url, headers \\ []) do
    headers = @default_headers ++ headers
    HTTPoison.head(url, headers, [])
  end

  @doc """
  Makes an OPTIONS request to the specified URL with optional headers.
  """
  def options(url, headers \\ []) do
    headers = @default_headers ++ headers
    HTTPoison.options(url, headers, [])
  end

  @doc """
  Builds a URL with query parameters.
  """
  def build_url_with_params(url, []) do
    url
  end

  def build_url_with_params(url, params) do
    query_string = URI.encode_query(params)
    "#{url}?#{query_string}"
  end

  @doc """
  Parses JSON response body. If parsing fails, returns the raw body as data.
  """
  def parse_json_response(
        {:ok, %HTTPoison.Response{body: body, status_code: status_code, headers: headers}}
      ) do
    case Jason.decode(body) do
      {:ok, data} -> {:ok, %{data: data, status: status_code, headers: headers}}
      {:error, _reason} -> {:ok, %{data: body, status: status_code, headers: headers}}
    end
  end

  def parse_json_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end
