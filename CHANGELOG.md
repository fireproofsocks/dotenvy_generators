# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v1.2.0

Tracks `Dotenvy` v1.2.0. Generated apps now require `{:dotenvy, "~> 1.2"}`.

Fixes in the generated `config/runtime.exs`:

- The Repo config is now wrapped in `<%= if @ecto do %>`, and the Swoosh/mailer
  config in `<%= if @mailer do %>`. Previously `--no-ecto` and `--no-mailer`
  produced an app whose runtime config referenced a `Repo` or `Mailer` module
  that was never generated, and `--no-ecto` also required `DATABASE_URL` to be
  set or the app would not boot.
- Removes hardcoded `SrcMe.Finch` and `config :src_me, SrcMe.Mailer` left over
  from the source project. `finch_name:` now uses the generated app's module.
- Uses the new `:ip!` cast for `HTTP_INTERFACE` in place of a hand-rolled
  parser that rejected compressed IPv6 addresses such as `::1`.
- Drops a `config :swoosh, api_client: ...` line that unconditionally overrode
  the `if`/`else` above it, making that branch dead.
- Renames `PHX_PLUGIN_INIT_MODE` to `PHX_PLUG_INIT_MODE` to match the
  `:plug_init_mode` key it sets, in both the runtime config and the env files.

Umbrella generator (`phx.new --umbrella`, `phx.new.web`):

- The umbrella path did not use `Dotenvy` at all. It generated stock Phoenix
  config: no `envs/` directory, no `dotenvy` dependency, and a `config/runtime.exs`
  whose entire contents sat inside `if config_env() == :prod do`.
- Adds `envs/.env`, `.dev.env`, `.test.env` and `.prod.env` templates and the
  `{:dotenvy, "~> 1.2"}` dependency.
- Rewrites both umbrella runtime templates to read values with `env!`, with no
  `config_env()` branching. `config_env()` is still used to select which env
  file to read, which is the intended pattern.
- The web app's runtime config is now registered as `:config` rather than
  `:prod_config`, so it is no longer injected into a prod-only block.
- Adds the `.overrides.env` line to both the single and umbrella `.gitignore`
  templates, which the README called for but neither had.

Other:

- Replaces the deprecated `:preferred_cli_env` with `def cli`.
- Adds `LICENSE` and `CHANGELOG.md` to the Hex package, and drops a `logo:`
  reference to a file that does not exist in the repo.

## v0.9.0

Initial release. Version number matches corresponding version of `Dotenvy`. Includes tasks:

- `dot.new`
- `phx.new.ecto`
- `phx.new`
- `phx.new.web`
