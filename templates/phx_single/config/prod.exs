import Config

# Compile-time configuration includes code_reloader, debug_errors, and force_ssl
# https://hexdocs.pm/phoenix/Phoenix.Endpoint.html#module-compile-time-configuration
config :<%= @app_name %>, <%= @endpoint_module %>,
  code_reloader: false,
  debug_errors: false,
  force_ssl: false

# Do not print debug messages in production
config :logger, level: :info
