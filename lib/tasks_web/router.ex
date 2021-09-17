defmodule TasksWeb.Router do
  use TasksWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
    plug(TasksWeb.Plugs.SetUser)
    plug(TasksWeb.Plugs.SessionTimeout, timeout_after_seconds: 3_600)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :csrf do
    plug :protect_from_forgery
  end

  pipeline :no_layout do
    plug :put_layout, false
  end

  scope "/", TasksWeb do
    pipe_through [:browser, :no_layout]

    get "/", RedirectController, :index
    get "/login", LoginController, :index
    get "/login/forgot_password", LoginController, :forgot_password
    post "/login/forgot_password", LoginController, :forgot_password
    get "/login/forgot_password/recover", LoginController, :recover
    post "/login/forgot_password/recover", LoginController, :recover
    post "/login/authenticate", SessionController, :authenticate
    get "/login/authenticate", SessionController, :authenticate
  end

  scope "/home", TasksWeb do
    pipe_through [:browser, :csrf, :api]

    get "/", DashboardController, :index

    match :*, "/admin/profile/users/:view", UserController, :redirect
    match :*, "/admin/recon/audits/:view", AuditsController, :redirect

    get "/dashboard/logout", SessionController, :sign_out

  end

  # Other scopes may use custom stacks.
  # scope "/api", TasksWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TasksWeb.Telemetry
    end
  end
end
