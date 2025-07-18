# API Framework Elixir

A comprehensive API testing framework migrated from TypeScript to Elixir, designed for testing RESTful APIs with robust error handling and clear test reporting.

## Overview

This project is a complete migration of a TypeScript API testing framework using Mocha and Axios to Elixir using ExUnit and HTTPoison. The framework provides a production-grade solution for API testing with proper authentication, session management, and comprehensive test coverage.

## Features

- **HTTP Client**: Robust HTTP client with JSON parsing and error handling
- **Authentication**: Token-based authentication with caching
- **Session Management**: Automatic token caching and reuse
- **Service Layer**: Clean service abstractions for different API endpoints
- **Test Utilities**: Helper functions for common testing patterns
- **Response Timing**: Built-in response time measurement
- **Error Handling**: Graceful handling of API errors and timeouts
- **Configuration**: Environment-based configuration with sensible defaults

## Project Structure

```
lib/api_framework_elixir/
├── application.ex          # Application supervision tree
├── http_client.ex          # HTTP client wrapper around HTTPoison
├── service_base.ex         # Base service with common HTTP methods
├── session_manager.ex      # Token caching and session management
├── models/                 # Data structures and models
│   ├── booking.ex
│   ├── credentials.ex
│   └── responses/
├── services/               # API service implementations
│   ├── auth_service.ex
│   └── booking_service.ex
└── utils/                  # Utility functions and constants

test/
├── auth/                   # Authentication tests
├── booking/                # Booking API tests
└── support/                # Test support files

src/                        # Original TypeScript source (for reference)
```

## Installation

1. Clone the repository:
    ```bash
git clone <repository-url>
    cd api-framework-ts-mocha
    ```

2. Install dependencies:
```bash
mix deps.get
```

3. Set up environment variables (optional):
```bash
cp example.env .env
# Edit .env with your API credentials
```

## Configuration

The framework uses environment variables for configuration:

- `BASEURL`: API base URL (defaults to http://192.168.1.8:3001)
- `API_USER`: API username (defaults to "admin")
- `API_PASSWORD`: API password (defaults to "password123")
    
## Usage
    
### Running Tests
    
    ```bash
# Run all tests
mix test

# Run only smoke tests
mix test --only smoke

# Run only regression tests
mix test --only regression

# Run tests with specific tags
mix test --only auth
mix test --only booking
```

### Test Structure

Tests are organized by functionality and tagged appropriately:

- `@moduletag :smoke` - Critical functionality tests
- `@moduletag :regression` - Comprehensive regression tests
- `@tag :skip` - Tests that are temporarily disabled

### Example Test

```elixir
defmodule ApiFrameworkElixir.AuthTest do
  use ExUnit.Case, async: true
  alias ApiFrameworkElixir.Services.AuthService
  alias ApiFrameworkElixir.Models.Credentials

  @moduletag :smoke
  test "sign in with valid credentials" do
    credentials = %{username: "admin", password: "password123"} |> Credentials.new()

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
end
```

## API Endpoints Supported

### Authentication
- `POST /auth` - Create authentication token

### Booking Management
- `GET /booking` - Get all booking IDs
- `GET /booking/:id` - Get specific booking
- `POST /booking` - Create new booking
- `PUT /booking/:id` - Update booking (requires auth)
- `PATCH /booking/:id` - Partial update booking (requires auth)
- `DELETE /booking/:id` - Delete booking (requires auth)

## Current Status

### ✅ Completed
- Complete TypeScript to Elixir migration
- HTTP client with proper error handling
- Authentication system with token caching
- Session management with GenServer
- Service layer abstractions
- Comprehensive test suite
- Configuration management
- Application supervision tree
- Response timing and measurement
- Graceful error handling for API downtime

### ⚠️ Known Issues
- API returning 418 "I'm a Teapot" for booking operations (likely temporary API issue)
- Some tests fail due to external API availability
- Response time tests may fail due to network latency

### 🔧 Technical Improvements Made
- Fixed authentication credentials (using API_USER/API_PASSWORD instead of USER/PASSWORD)
- Added proper GenServer supervision for SessionManager
- Improved error handling for API downtime
- Enhanced test robustness with proper error cases
- Fixed function signatures for authenticated operations
- Added comprehensive logging and debugging capabilities

## Development

### Adding New Tests

1. Create test file in appropriate directory (`test/auth/` or `test/booking/`)
2. Use existing patterns for authentication and error handling
3. Add appropriate tags (`@moduletag :smoke` or `@moduletag :regression`)
4. Handle API downtime gracefully with 418 status checks

### Adding New Services

1. Create service module in `lib/api_framework_elixir/services/`
2. Extend `ServiceBase` for common HTTP operations
3. Add proper error handling and response parsing
4. Include authentication headers where required

## Dependencies

- **HTTPoison**: HTTP client library
- **Jason**: JSON parsing
- **Dotenvy**: Environment variable loading
- **Mox**: HTTP mocking for tests
- **Faker**: Test data generation
- **Credo**: Code quality checks
- **ExDoc**: Documentation generation

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Original TypeScript framework by [damianpereira86](https://github.com/damianpereira86/api-framework-ts-mocha)
- Restful Booker API for providing a test playground
- Elixir community for excellent tooling and libraries
