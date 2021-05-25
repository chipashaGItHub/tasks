defmodule TasksWeb.Plugs.SetUser do
  @behaviour Plug
  import Plug.Conn

  @moduledoc false


  def init(_params) do
  end

  def call(conn, _params) do
    user_id = get_session(conn, :current_user)

    cond do
      # USE ENDON TO FIND BY USER BY ID
      user = user_id && Tasks.Database.Schema.User.find_by(id: user_id) -> assign(conn, :user, user)
      true -> assign(conn, :user, nil)
    end
  end

end
