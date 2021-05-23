defmodule TasksWeb.RedirectController do
  use TasksWeb, :controller

  def index(conn, params) do
    conn |> redirect(to: Routes.login_path(conn, :index))
  end
end