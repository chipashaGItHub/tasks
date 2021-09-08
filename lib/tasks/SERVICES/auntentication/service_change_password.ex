defmodule Tasks.Services.ChangePassword do
  use TasksWeb, :universal


  def update_password(conn, params) do
    multiple = Ecto.Multi.new()
    {:ok, response} = password(conn.assigns.user.id, params["old_pass"])
    cond do
      response == false -> %{status: 1, message: "Old Password provided doesnt match the existing password! Update Password Failed!"}
      true -> password(conn, params["new_pass"], multiple, response)
    end

  end


  def password(id, old_pass) do
    validate_password = (fn (id, password) ->
      User.find_by(id: id)
      |> case  do
           nil -> {:ok, false}
           user ->
             case Tasks.Hash.hash("#{user.username}#{password}") == user.password  do
               true -> {:ok, user}
               false -> {:ok, false}
             end
         end
                         end)

    validate_password.(id, old_pass)
  end

  def password(conn, new_pass, multiple, user) do
    try do
      multiple
      |> Ecto.Multi.update(:user, Ecto.Changeset.change(user, %{password: new_pass |> Aggregator.HashModule.hash()}))
      |> Repo.transaction()
      |> case  do
           {:ok, _trans} ->
             Aggregator.GlobalFunctions.Audit_trails.audit(conn, user.username, "UPDATE PASSWORD", "SUCCESSFUL UPDATE PASSWORD", user.id |> to_string, "Password update was initiated on: #{Aggregator.GlobalFunctions.Time.local_time()}", "#{user.first_name} #{user.last_name} UPDATE PASSWORD", "update password was successful!. Action taken on: #{Aggregator.GlobalFunctions.Time.local_time()}")
             %{status: 0, message: "Password has been Updated Successfully!"}
           {:error, _, error, _} ->
             Aggregator.GlobalFunctions.Audit_trails.audit(conn, user.username, "UPDATE PASSWORD", "FAILED UPDATE PASSWORD", "", "Password update was initiated on: #{Aggregator.GlobalFunctions.Time.local_time()}", "UPDATE PASSWORD", "Failed update Password!. Action taken on: #{Aggregator.GlobalFunctions.Time.local_time()} with status failed due to: #{error.message}")
             %{status: 1, message: error.message}
         end
    rescue
      _->
        Aggregator.GlobalFunctions.Audit_trails.audit(conn, user.username, "UPDATE PASSWORD", "FAILED UPDATE PASSWORD", "", "Password update was initiated on: #{Aggregator.GlobalFunctions.Time.local_time()}", "UPDATE PASSWORD", "Failed update Password!. Action taken on: #{Aggregator.GlobalFunctions.Time.local_time()} with status failed due to exception error")
        %{status: 1, message: "Failed to update password due to an exception error!"}
    end
  end

end