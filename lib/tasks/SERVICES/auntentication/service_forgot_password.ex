defmodule Tasks.Services.ResetPassword do
  use TasksWeb, :universal

  @length 10

  def   reset(conn, params) do
    multiple = Ecto.Multi.new()
    map = (fn x ->
      Enum.reduce(x, %User{}, fn {k,v}, map ->
        Map.merge(map, %{"#{k}": if v == "true" do true else v end})
      end)
           end)
    profile = (fn username -> Repo.all(from(x in User, where: x.username == ^username)) |> Enum.at(0) end)

    try do
      multiple
      |> Ecto.Multi.run(:recover, fn _repo, _changes ->
        User.find_by(username: params["username"])
        |> case do
             nil-> {:error, %{message: "No account exist with username #{params["username"]}!"}}
             user ->  {:ok, %{password: Tasks.Utility.Randomizer.randomizer(@length, :alpha)}}
           end
      end)
      |> Ecto.Multi.update(:user, fn %{recover: recover} ->
        Ecto.Changeset.change(User.find_by(username: params["username"]), %{password: recover.password |> Tasks.Hash.hash()})
      end)
      |> Ecto.Multi.run(:sms, fn _repo, %{recover: recover, user: user} -> users = profile.(params["username"])
          Tasks.Service.Emails.insert(%Tasks.Database.Schema.Emails{message: "Dear #{users.first_name} #{users.last_name} \n Your password has been reset successfully. \n Your New password is: #{recover.password}, \n\n Regards. Tasks", email: user.email, status: "PENDING"})
      end)
      |> Repo.transaction()
      |> case  do
           {:ok, %{recover: recover}} ->  user = profile.(params["username"])
            Tasks.Service.System.Logs.index(conn, user.username, "RESET PASSWORD", "SUCCESSFUL RESET PASSWORD", user.id |> to_string, "Password reset was initiated on: #{Tasks.Utility.Time.local_time()}", "#{user.first_name} #{user.last_name} RESET PASSWORD", "Reset password was successful!. Action taken on: #{Tasks.Utility.Time.local_time()}")
            %{status: 0, message: "Password has been Reset Successfully! Recovery Email has been Sent!"}
           {:error, _, error, _} ->
             Tasks.Service.System.Logs.index(conn, params["username"], "RESET PASSWORD", "FAILED RESET PASSWORD", "", "Password reset was initiated on: #{Tasks.Utility.Time.local_time()}", "RESET PASSWORD", "Failed Reset Password!. Action taken on: #{Tasks.Utility.Time.local_time()} with status failed due to: #{error.message}")
             %{status: 1, message: error.message}
         end
    rescue
      _->
        Tasks.Service.System.Logs.index(conn, params["username"], "RESET PASSWORD", "FAILED RESET PASSWORD", "", "Password reset was initiated on: #{Tasks.Utility.Time.local_time()}", "RESET PASSWORD", "Failed Reset Password!. Action taken on: #{Tasks.Utility.Time.local_time()} with status failed due to exception error")
        %{status: 1, message: "Failed to reset password due to an exception error!"}
    end
  end


end