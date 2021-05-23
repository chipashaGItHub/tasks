defmodule TasksWeb.LoginController do
  use TasksWeb, :controller

  def index(conn, _params) do
    conn |> render("index.html")
  end

  def forgot_password(conn, params) do
    conn |> render("forgot.html")
  end
end