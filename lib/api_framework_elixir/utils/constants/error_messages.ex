defmodule ApiFrameworkElixir.Utils.Constants.ErrorMessages do
  @moduledoc """
  Error message constants used throughout the framework.
  This replaces the TypeScript error-messages constants.
  """

  @bad_request "Bad Request"
  @not_found "Not Found"
  @unauthorized "Full authentication is required to access this resource"

  def bad_request, do: @bad_request
  def not_found, do: @not_found
  def unauthorized, do: @unauthorized
end
