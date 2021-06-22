defmodule Tasks.Service.System.Logs do
  use TasksWeb, :universal

  def index(conn, username, narration, action_type, user_id, reference, reference2, description) do
    try do
      Multi.new()
      |> Multi.insert(:logs, %Logs{narration: narration, reference: reference, reference2: reference2,
        username: username, user_id: user_id, description: description,
        actionType: action_type, ip_address: try do ip_address(conn) rescue _-> "-" end})
      |> Repo.transaction()
      |> case do
           {:ok, _} -> {:ok, :error}
           {:error, _} -> {:ok, :error}
         end
    rescue
      _->
        Multi.new()
        |> Multi.insert(:failed, %Logs{
          narration: "Failed to update logs due to an exception error!", reference: reference, reference2: reference2,
          username: username, user_id: user_id, description: description,
          actionType: action_type, ip_address: ip_address(conn)})
        |> Repo.transaction()
        |> case do
             {:ok, _} -> {:ok, :error}
             {:error, _} -> {:ok, :error}
           end
    end
  end

  def ip_address(conn), do: conn.remote_ip |> :inet_parse.ntoa |> to_string()
end