defmodule CardSim.MixProject do
  use Mix.Project

  def project do
    [
      app: :card_sim,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end
  
  defp description() do
    "Playing card game simulation library for Elixir."
  end
  
  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "card_sim",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["GPL-3.0-or-later"],
      links: %{"GitHub" => "https://github.com/jimurrito/cardsim"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools, :wx, :observer]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
