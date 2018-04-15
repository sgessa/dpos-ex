defmodule Dpos.MixProject do
  use Mix.Project

  @version "0.1.0"
  @url "https://github.com/lwf/dpos-elixir"
  @maintainers ["Stefano Gessa"]

  def project do
    [
      name: "DPoS",
      maintainers: @maintainers,
      app: :dpos,
      version: @version,
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:salty, "~> 0.1.3", hex: :libsalty}
    ]
  end

  def docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @url,
      extras: ["README.md"]
    ]
  end

  defp package do
    [
      maintainers: @maintainers,
      licenses: ["MIT"],
      links: %{github: @url},
      files: ~w(lib) ++ ~w(CHANGELOG.md LICENSE mix.exs README.md)
    ]
  end
end
