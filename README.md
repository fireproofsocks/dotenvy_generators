# Dotenvy Generators

Provides alternative Phoenix generators (`phx.new` et al) that leverage [Dotenvy](https://hexdocs.pm/dotenvy/) for application configuration.

The Phoenix tasks are intended to *replace* any existing Phoenix installers (available as the `phx_new` archive).

Based off version `1.8.0-dev` of the Phoenix installers.

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
