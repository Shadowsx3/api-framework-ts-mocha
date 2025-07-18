defmodule ApiFrameworkElixir.SessionManager do
  @moduledoc """
  Session manager for caching authentication tokens.
  This module replaces the TypeScript SessionManager functionality.
  """

  use GenServer

  @doc """
  Starts the session manager process.
  """
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @doc """
  Gets a cached token for the given username and password.
  """
  def get_cached_token(username, password) do
    cache_key = "#{username}:#{password}"
    GenServer.call(__MODULE__, {:get_token, cache_key})
  end

  @doc """
  Stores a token for the given username and password.
  """
  def store_token(username, password, token) do
    cache_key = "#{username}:#{password}"
    GenServer.cast(__MODULE__, {:store_token, cache_key, token})
  end

  @doc """
  Clears all cached tokens.
  """
  def clear_cache do
    GenServer.cast(__MODULE__, :clear_cache)
  end

  # GenServer callbacks

  @impl true
  def init(_opts) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:get_token, cache_key}, _from, state) do
    token = Map.get(state, cache_key)
    {:reply, token, state}
  end

  @impl true
  def handle_cast({:store_token, cache_key, token}, state) do
    new_state = Map.put(state, cache_key, token)
    {:noreply, new_state}
  end

  @impl true
  def handle_cast(:clear_cache, _state) do
    {:noreply, %{}}
  end
end 