defmodule DotenvyGenerators.MixProject do
  use Mix.Project

  @source_url "https://github.com/fireproofsocks/dotenvy_generators"
  @version "0.9.0"

  def project do
    [
      app: :dotenvy_generators,
      version: @version,
      phoenix_version: "1.7.18",
      description:
        "Generators for Elixir apps using Dotenvy for config including variants of the phx_new generators",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: [
        source_ref: "v#{@version}",
        source_url: @source_url,
        extras: extras()
      ]
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

  def extras do
    [
      "CHANGELOG.md"
    ]
  end

  def links do
    %{
      "GitHub" => @source_url,
      "Readme" => "#{@source_url}/blob/v#{@version}/README.md",
      "Changelog" => "#{@source_url}/blob/v#{@version}/CHANGELOG.md"
    }
  end

  defp package do
    [
      maintainers: ["Everett Griffiths"],
      licenses: ["Apache-2.0"],
      logo: "assets/logo.png",
      links: links(),
      files: [
        "lib",
        "mix.exs",
        "README*",
        "CHANGELOG*",
        "LICENSE*"
      ]
    ]
  end
end
