defmodule WeatherScraper.MixProject do
  use Mix.Project

  def project do
    [
      app: :weather_scraper,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [main_module: WeatherScraper.CLI]
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
    [
      {:httpoison, "~> 2.0"},
      {:floki,      "~> 0.34"},
      {:ex_doc,     "~> 0.30", only: :dev, runtime: false}
    ]
  end
end
