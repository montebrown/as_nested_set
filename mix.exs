defmodule AsNestedSet.Mixfile do
  use Mix.Project

  def project do
    [
      app: :as_nested_set,
      version: "3.4.1",
      elixir: "~> 1.16",
      elixirc_paths: elixirc_paths(Mix.env()),
      description: description(),
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.travis": :test
      ]
    ]
  end

  defp description do
    """
    An ecto based Nested set model implementation
    """
  end

  defp package do
    [
      name: :as_nested_set,
      files: ["lib", "priv", "mix.exs", "README*", "LICENSE*", "CHANGELOG*"],
      maintainers: ["dusiyh@gmail.com"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/secretworry/as_nested_set"}
    ]
  end

  def application do
    [applications: app_list(Mix.env())]
  end

  def app_list(:test), do: app_list() ++ [:postgrex, :ex_machina]
  def app_list(_), do: app_list()
  def app_list, do: [:ecto, :logger]

  defp deps do
    [
      {:ecto, "~> 3.10"},
      {:ecto_sql, "~> 3.10"},
      {:ex_doc, ">= 0.18.3", only: :dev},
      {:postgrex, "~> 0.16.0", only: :test},
      {:ex_machina, "~> 2.2", only: [:test]},
      {:excoveralls, "~> 0.12", only: [:test]}
    ]
  end

  defp elixirc_paths(:test), do: elixirc_paths() ++ ["test/support"]
  defp elixirc_paths(_), do: elixirc_paths()
  defp elixirc_paths, do: ["lib"]
end
