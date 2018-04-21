defmodule VisaCheckoutElixir.Mixfile do
  use Mix.Project

  def project do
    [
      app: :visa_checkout_elixir,
      version: "1.0.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      description: description(),
      package: package()
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
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:ex_doc, "~> 0.14", only: :dev},
    ]
  end

  defp description do
    """
      A Visa Checkout library for Elixir.
    """
  end

  defp package do
    [
      files: ~w(mix.exs README.md lib),
      maintainers: ["belloq"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/belloq/visa_checkout_elixir"
      }
    ]
  end
end
