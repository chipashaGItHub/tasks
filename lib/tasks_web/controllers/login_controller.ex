defmodule TasksWeb.LoginController do
  use TasksWeb, :controller

  def index(conn, _params) do
    conn |> render("index.html")
  end

  def forgot_password(conn, params) do
    conn |> render("forgot.html")
  end

  def recover(conn, params) do
    result = Tasks.Service.ForgotPassword.recover(conn, params)
    result.status
    |> case  do
          0 ->
          conn
          |> put_flash(:info, result.message)
          |> redirect(to: Routes.login_path(conn, :index))
          1 ->
          conn
          |> put_flash(:error, result.message)
          |> redirect(to: Routes.login_path(conn, :forgot_password))
       end
  end
end