# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :tasks,
  ecto_repos: [Tasks.Repo]

#Endon configurations
config :endon,
       repo: Tasks.Repo

# email configs
config :tasks, Tasks.Mailer,
       adapter: Bamboo.SMTPAdapter,
       server: "smtp.gmail.com", #smtp.office365.com
       port: 587,
       username: "mvulajohn360@gmail.com",
       password: "mvula@360",
       tls: :if_available, # can be `:always` or `:never`
       allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
       ssl: false, # can be `true`
       retries: 3

# Configures the endpoint
config :tasks, TasksWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rgmXAhvvaDXsOjM5VndpAj+V1kN4O5h8qNle7wMYQEcCDGM5DkiJw1un2YoTvsum",
  render_errors: [view: TasksWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Tasks.PubSub,
  live_view: [signing_salt: "/CCOwEtb"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
