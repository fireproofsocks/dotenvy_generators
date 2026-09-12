# We `require` the Config module here rather than importing it. That gives us
# Config.config_env/0 for choosing which env file to read, while leaving the
# import further down as the first one in this file, which is the point where
# the web app's endpoint config gets injected.
require Config
import Dotenvy

# For local development, read dotenv files inside the envs/ dir;
# for releases, read them at the RELEASE_ROOT
env_dir_prefix = System.get_env("RELEASE_ROOT") || Path.expand("./envs/") <> "/"

source!([
  "#{env_dir_prefix}.env",
  "#{env_dir_prefix}.#{Config.config_env()}.env",
  "#{env_dir_prefix}.#{Config.config_env()}.overrides.env",
  System.get_env()
])

# config/runtime.exs is executed for all environments, including during
# releases. It is executed after compilation and before the system starts.
# Do not define any compile-time configuration in here, as it won't be applied.
#
# Every value below is read at runtime from the env files sourced above, so
# there is no need to branch on config_env() here: the values differ because
# the files differ.

import Config

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by setting PHX_SERVER=true in the appropriate env file, or by passing
# it when you start the release:
#
#     PHX_SERVER=true bin/<%= @app_name %> start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.
if env!("PHX_SERVER", :boolean!) do
  config :<%= @web_app_name %>, <%= @endpoint_module %>, server: true
end

config :<%= @app_name %>, :dns_cluster_query, env!("DNS_CLUSTER_QUERY", :string?)
