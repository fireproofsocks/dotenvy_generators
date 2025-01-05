# Dotenvy Generators

Provides alternative Phoenix generators (`phx.new` et al) that leverage [Dotenvy](https://hexdocs.pm/dotenvy/) for application configuration.

The following generators are included:

- `dot.new` a variant of the vanilla `mix new` command, but using `Dotenvy`
- `phx.new.ecto`
- `phx.new`
- `phx.new.web`

The Phoenix tasks are intended to *replace* any existing Phoenix installers (available as the `phx_new` archive).

Based off version `1.7.18` of the Phoenix installers.

This repo provides Mix tasks as an archive.

## Installation

### Hex installation

Because these variants are designed to replace their Phoenix counterparts, it is advised to first uninstall any existing Phoenix generators:

    mix archive.uninstall phx_new
    mix archive.install hex dotenvy_generators

### To build and install locally

Ensure the conflicting Phoenix generators are removed:

    mix archive.uninstall phx_new

Then run:

    cd dotenvy_generators
    MIX_ENV=prod mix do archive.build, archive.install

## Development

During development/testing of the generators, you will first build the generators to see if there are any errors:

    mix archive.build

Then you can run `mix help` to verify that any new tasks have been compiled and are visible:

    mix help

If everything looks ok, then you can run `archive.install` and try running the generator elsewhere.

### Updating the generators

This repo must play cat and mouse with the original Phoenix generators, which are updated separately.  Periodically, we will need to update these generators so they follow whatever updates have been introduced to

1. Clone the `phoenix` repo.
2. Checkout the latest tag.
3. Recursively copy the contents of the `installer/lib/` and `installer/templates/` directories into the root of this repo.  Make sure you merge the contents -- don't just overwrite because we want to preserve the `dot_new` folder and custom mix tasks.
4. Inside the `Phx.New.Single` module, update the

        {
            :config,
            :project,
            "phx_single/config/config.exs": "config/config.exs",
            "phx_single/config/dev.exs": "config/dev.exs",
            "phx_single/config/prod.exs": "config/prod.exs",
            "phx_single/config/runtime.exs": "config/runtime.exs",
            "phx_single/config/test.exs": "config/test.exs"
        },
        {
            :eex,
            :project,
            "phx_single/envs/.env": "envs/.env",
            "phx_single/envs/.dev.env": "envs/.dev.env",
            "phx_single/envs/.test.env": "envs/.test.env",
            "phx_single/envs/.prod.env": "envs/.prod.env"
        },

Inside `Phx.New.Single` we have to comment out the call to `gen_ecto_config` because it deviates from how we want to configure our app.  In particular, we want to be wary about any environment sniffing, e.g. `if config_env() == :prod do`, because that can be used in ways that are problematic.

        def gen_ecto(project) do
            copy_from(project, __MODULE__, :ecto)
            # This function is opinionated about how things are configured :(
            # gen_ecto_config(project)
        end

Inside `Phx.New.Generator`, we need to decouple the version of the Phoenix app being generated from the version of *this repo* (i.e. `dotenvy_generators`). We need to change

    @phoenix_version Version.parse!(Mix.Project.config()[:version])

To this:

    @phoenix_version Version.parse!(Mix.Project.config()[:phoenix_version])`

Make sure the `mix.exs` references the appropriate version/tag of `phoenix` that you cloned!

Update the `templates/phx_single/mix.exs` so it includes overlays in its releases:

    defp releases do
        [
            <%= @app_name %>: [
                overlays: ["envs/"]
            ]
        ]
    end

and ensure the latest `dotenvy` in the dependencies, e.g.

        {:dotenvy, "~> 0.9.0"}

The `templates/phx_single/gitignore` file should include a line to ignore `.overrides.env`:

        # Ignore custom overrides of .env files
        .overrides.env

`phx.new.ex` should update its `@moduledoce` description so it mentions `Dotenvy`:

        Creates a new Phoenix project using `Dotenvy` for configuration.

And do the same for its `@shortdoc`:

        @shortdoc "Creates a new Phoenix v#{@version} application using Dotenvy"

Update the `@version` attribute and some of the info so it's clear that this is a modified version of the original generator:

        @version Mix.Project.config()[:phoenix_version]

        Mix.shell().info("Phoenix installer (Dotenvy) v#{@version}")

We can delete the `local.phx.ex` task for now.

To publish an updated version:

        MIX_ENV=docs mix hex.publish
