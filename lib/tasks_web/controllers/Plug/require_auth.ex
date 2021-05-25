defmodule TasksWeb.Plugs.RequireAuth do
  @behaviour Plug
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  @moduledoc false

  def init(_params) do
  end

  def call(conn, _params) do
    if get_session(conn, :current_user) do
      conn
    else
      conn
      |> put_flash(:error, "your session has expired! you must login to continue")
      |> redirect(to: TasksWeb.Router.Helpers.session_path(conn, :sign_out))
      |> halt()
    end
  end
end
