Dotenvy.source!(".env")
ExUnit.start(max_cases: System.schedulers_online() * 2)

# Start the session manager for tests
ApiFrameworkElixir.SessionManager.start_link([])
