import Config

# Test-specific configuration
config :api_framework_elixir, :test,
  base_url: System.get_env("BASEURL") || "http://localhost:3001",
  username: System.get_env("USER"),
  password: System.get_env("PASSWORD")

# Configure ExUnit for testing
config :exunit,
  capture_log: true,
  trace: true,
  timeout: 10_000

# Configure Mox for mocking
config :api_framework_elixir,
  http_client: ApiFrameworkElixir.HTTPClient
