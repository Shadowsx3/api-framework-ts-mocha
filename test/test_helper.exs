Dotenvy.source!(".env")
ExUnit.start(max_cases: System.schedulers_online() * 10)

# Start the session manager for tests
ApiFrameworkElixir.SessionManager.start_link([])
