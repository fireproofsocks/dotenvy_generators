import Config

config :<%= @web_app_name %>, <%= @endpoint_module %>,
  http: [
    # The interface(s) to listen on. `127.0.0.1` restricts access to this
    # machine; `0.0.0.0` (IPv4) or `::` (IPv6) binds all interfaces.
    ip: env!("HTTP_INTERFACE", :ip!),
    port: env!("PORT", :integer!)
  ],
  secret_key_base: env!("SECRET_KEY_BASE", :string!)

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to your endpoint configuration:
#
#     config :<%= @web_app_name %>, <%= @endpoint_module %>,
#       https: [
#         ...,
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: env!("SSL_KEY_PATH", :string!),
#         certfile: env!("SSL_CERT_PATH", :string!)
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your config/prod.exs,
# ensuring no data is ever sent via http, always redirecting to https:
#
#     config :<%= @web_app_name %>, <%= @endpoint_module %>,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.<%= if @mailer do %>

# ## Configuring the mailer
#
# In production you need to configure the mailer to use a different adapter.
# Name the adapter in an env file and read it here, e.g.
#
#     config :<%= @app_name %>, <%= @app_module %>.Mailer,
#       adapter: env!("SWOOSH_MAILER_ADAPTER", :module!),
#       api_key: env!("MAILGUN_API_KEY", :string!),
#       domain: env!("MAILGUN_DOMAIN", :string!)
#
# Most non-SMTP adapters require an API client. Swoosh supports Hackney and
# Finch out of the box:
#
#     config :swoosh, :api_client, env!("SWOOSH_API_CLIENT", :module!)
#
# See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.<% end %>
