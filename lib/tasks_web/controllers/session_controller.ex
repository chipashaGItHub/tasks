defmodule TasksWeb.SessionController do
  use TasksWeb, :controller
  use TasksWeb, :universal

  def authenticate(conn, params) do
    message = (fn user ->
      if user.last_login_date == nil do "Welcome #{user.first_name} #{user.last_name}" else "Welcome Back #{user.first_name} #{user.last_name}, you last logged in on the #{user.last_login_date |> Utility.format_date()}" end
               end)
    Plug.Conn.configure_session(conn, drop: true)
    Tasks.Service.System.Logs.index(conn, params["username"], "#{params["username"]} LOG IN ATTEMPT", "LOG IN ATTEMPT", nil, "#{params["username"]} attempted login on date: #{Tasks.Utility.Time.local_time() |> to_string}", "0.0", "LOGIN BUTTON ATTEMPTED!")
    case Tasks.Service.Authenticate.authenticate_user(conn, params) do
      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.login_path(conn, :index))
      {:ok, user} ->
        conn
        |> put_flash(:info, message.(user))
        |> put_session(:current_user, user.id)
        |> put_session(:session_timeout_at, session_timeout_at())
        |> redirect(to: Routes.dashboard_path(conn, :index))
    end
  end

  defp session_timeout_at do
    DateTime.utc_now() |> DateTime.to_unix() |> (&(&1 + 3_600)).()
  end


  def sign_out(conn, _params) do
    user = conn.assigns.user
    Tasks.Service.System.Logs.index(conn, user.username, "#{user.username} LOGOUT ATTEMPT", "LOGOUT ATTEMPT", user.id, "#{user.username} has successfully logged out of the system on date: #{Tasks.Utility.Time.local_time() |> to_string}", "1.0", "LOG-OUT BUTTON ATTEMPTED!")
    |> case do
         {:ok, _} ->
           conn
           |> configure_session(drop: true)
           |> redirect(to: Routes.login_path(conn, :index))
       end
  rescue
    _ ->
      conn
      |> configure_session(drop: true)
      |> redirect(to: Routes.login_path(conn, :index))
  end
end