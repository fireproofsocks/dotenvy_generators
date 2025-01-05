import Config

# Compile-time configuration includes code_reloader, debug_errors, and force_ssl
# https://hexdocs.pm/phoenix/Phoenix.Endpoint.html#module-compile-time-configuration
config :<%= @app_name %>, <%= @endpoint_module %>,
  code_reloader: true,
  debug_errors: true,
  force_ssl: false,
  # Watch static and templates for browser reloading.
  live_reload: [
    web_console_logger: true,
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",<%= if @gettext do %>
      ~r"priv/gettext/.*(po)$",<% end %>
      ~r"lib/<%= @lib_web_name %>/(controllers|live|components)/.*(ex|heex)$"
    ]
  ],
  # The watchers configuration can be used to run external
  # watchers to your application. For example, we can use it
  # to bundle .js and .css sources.
  # Watchers can be configured at runtime but are unlikely to change
  watchers: <%= if @javascript or @css do %>[<%= if @javascript do %>
    esbuild: {Esbuild, :install_and_run, [:<%= @app_name %>, ~w(--sourcemap=inline --watch)]}<%= if @css, do: "," %><% end %><%= if @css do %>
    tailwind: {Tailwind, :install_and_run, [:<%= @app_name %>, ~w(--watch)]}<% end %>
  ]<% else %>[]<% end %>

# Compile-time config
config :phoenix_live_view,
  debug_heex_annotations: true,
  enable_expensive_runtime_checks: true

# Enable dev routes for dashboard and mailbox (compile-time config)
config :<%= @app_name %>, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"
