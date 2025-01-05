defmodule DotenvyGenerators.MixProject do
  use Mix.Project

  def project do
    [
      app: :dotenvy_generators,
      version: "0.1.0",
      phoenix_version: "1.7.18",
      description:
        "Generators for Elixir apps using Dotenvy for config including variants of the phx_new generators",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    []
  end
end
