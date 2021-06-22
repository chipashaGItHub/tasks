defmodule TasksWeb.DashboardController do
  use TasksWeb, :controller
  use TasksWeb, :universal

  def index(conn, params) do
    conn |> render("index.html")
  end
end