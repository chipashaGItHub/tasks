defmodule Tasks.MixProject do
  use Mix.Project

  def project do
    [
      app: :tasks,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Tasks.Application, []},
      include_executables_for: [:unix],
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.8"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
#      {:postgrex, ">= 0.0.0"},
      {:tds, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:endon, "~> 1.0"},
      {:bcrypt_elixir, "~> 0.12"},
      {:httpoison, "~> 1.6"},
      {:poison, "~> 3.1.0"},
      {:pdf_generator, ">=0.4.0"},
      {:sneeze, "~> 1.1"},
      {:bbmustache, github: "soranoba/bbmustache"},
      {:calendar, "~> 0.17.0"},
      {:timex, "~> 3.5"},
      {:scrivener_ecto, "~> 2.6.0", override: true},
      {:browser, "~> 0.1.0"},
      {:number, "~> 0.5.6"},
      {:bamboo, "~> 2.0.1"},
      {:bamboo_smtp, "~> 4.0.0"},
      {:xlsxir, "~> 1.6.4"},
      {:csv, "~> 2.3"},
      {:elixlsx, "~> 0.4.2"},
      {:uuid, "~> 1.1"},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
