defmodule TasksWeb.LoginController do
  use TasksWeb, :controller

  def index(conn, _params) do
    conn |> render("index.html")
  end

  def forgot_password(conn, params) do
    conn |> render("forgot.html")
  end

  def recover(conn, params) do
    result = Tasks.Services.ResetPassword.reset(conn, params)
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

  def change_password(conn, _params) do
    conn |> render("change_password.html")
  end



  def update_password(conn, params) do
    case params["new_pass"] != params["confirm_pass"] do
      true ->
        conn
        |> put_flash(:error, "Password didnt match. Try Again!")
        |> redirect(to: Routes.login_path(conn, :change))
      false ->
        result = Tasks.Services.ChangePassword.update_password(conn, params |> Map.delete("_csrf_token"))
        result.status
        |> case  do
             0 ->
               conn
               |> put_flash(:info, result.message)
               |> redirect(to: Routes.login_path(conn, :change))

             1 ->
               conn
               |> put_flash(:error, result.message)
               |> redirect(to: Routes.login_path(conn, :change))
           end

    end
  end

end