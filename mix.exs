defmodule ApiFrameworkElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :api_framework_elixir,
      version: "1.0.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_paths: ["test"],
      test_pattern: "**/*_test.exs",
      elixirc_paths: elixirc_paths(Mix.env()),
      preferred_cli_env: [
        test: :test,
        smoke: :test,
        regression: :test
      ]
    ]
  end

  def application do
    [
      mod: {ApiFrameworkElixir.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp deps do
    [
      # HTTP client
      {:httpoison, "~> 2.0"},
      # JSON parsing
      {:jason, "~> 1.4"},
      # Environment variables
      {:dotenvy, "~> 0.8"},
      # HTTP mocking for tests
      {:mox, "~> 1.1", only: :test},
      # Test data generation
      {:faker, "~> 0.17", only: :test},
      # Code formatting
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      # Documentation
      {:ex_doc, "~> 0.29", only: :dev, runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
