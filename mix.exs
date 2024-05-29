defmodule Dpos.MixProject do
  use Mix.Project

  @desc "DPoS offline and online tools for Elixir"
  @version "0.3.1"
  @url "https://github.com/sgessa/dpos-ex"
  @maintainers ["Stefano Gessa"]

  def project do
    [
      app: :dpos,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Hex
      package: package(),
      description: @desc,
      source_url: @url,

      # Docs
      name: "DPoS",
      docs: docs()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:httpoison, "~> 1.0"},
      {:jason, "~> 1.0"}
    ]
  end

  def docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      extras: ["README.md", "LICENSE.txt"]
    ]
  end

  defp package do
    [
      maintainers: @maintainers,
      licenses: ["MIT"],
      links: %{"GitHub" => @url}
    ]
  end
end
