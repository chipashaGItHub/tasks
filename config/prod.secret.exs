# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

config :nrfa_elixir, NrfaElixir.Repo,
       hostname: "154.120.217.204",
       username: "sa",
       password: "Qwerty12",
       database: "tasks_dev",
       port: 1433,
       pool_size: 100,
         # ownership_timeout: 60_000
       timeout: 80_000,
       pool_timeout: 80_000

config :nrfa_elixir, NrfaElixirWeb.Endpoint,
       http: [
         port: String.to_integer(System.get_env("PORT") || "4500"),
         transport_options: [socket_opts: [:inet6]]
       ],
       secret_key_base: "uBR0SiguwV3nlZlkL8Ov8FvdZnSvduy1c9UQXCBfn4Lxy6kRAoqHMgPZOxwlyaW/"

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :tasks, TasksWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
