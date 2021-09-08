defmodule Tasks.Service.Authenticate do
  use TasksWeb, :universal

  def authenticate_user(conn, params) do
    case params["username"] == "" do
      true -> %{message: "No fields entered!", status: 1}
      false ->
        User.find_by(username: params["username"])
        |> case do
             nil -> user_logs(conn, params["username"], nil, "LogIn Failed: Invalid User Name", "LogIn Failed: Invalid User Name", "Invalid Username/Password")
             user -> password_verification(conn, user, params)
           end
    end
  end

  defp password_verification(conn, user, params) do
    case Tasks.Hash.hash("#{user.username}#{params["password"]}") == user.password do
      false -> Tasks.Service.System.Logs.index(conn, user.username, "LOGIN ATTEMPT", "USER LOGIN", user.id, "log in on: #{Tasks.Utility.Time.local_time()}", "#{user.first_name} #{user.last_name} LOGIN", "LogIn Failed: Invalid Password")
               |> case do
                    {:ok, _} -> attempts_validation(conn, user, params)
                  end
      true -> user_verification(conn, user, params)
    end
  end

  defp user_verification(conn, user, params) do
    case user.status == false do
      true -> user_logs(conn, params["username"], user.id, user.email, "LogIn Failed: User Disabled", "User Disabled! Contact Administrator for Activation")
      false ->
        case user.blocked == true do
          true -> user_logs(conn, params["username"], user.id, user.email, "LogIn Failed: User Disabled", "User Blocked by System! Contact Administrator for Activation or Try Again Tomorrow")
          false -> password_passed(conn, user, params)
        end
    end
  end

  defp password_passed(conn, user, _params) do
    User.update(user, failed_attempts: 0)
        Tasks.Service.System.Logs.index(conn, user.username, "LOGIN ATTEMPT", "USER LOGIN", user.id, "logged in on: #{Tasks.Utility.Time.local_time()}", "Login Successfully", "Login was successful")
    |> case do
         {:ok, _} ->
           User.update(user, last_login_date: Tasks.Utility.Time.local_time())
           |> case do
                {:ok, _}-> {:ok, user}
              end
       end
  end

  defp attempts_validation(conn, user, params) do
    case user.failed_attempts == nil do
      true ->
        IO.inspect("############ Updating failed Attempts ####################")
        User.update(user, failed_attempts: 0)
        |> case do
             {:ok, user} ->
               IO.inspect("############ Successfully updated failed Attempts ####################")
               attempts_checker(conn, user, params)
             {:error, error} -> IO.inspect(error.errors)
           end
      false ->
        IO.inspect("############ Updating failed Attempts ####################")
        attempts_checker(conn, user, params)
    end
  end

  defp attempts_checker(conn, user, params) do
    attempts = attempts.attempts
    User.update(user, failed_attempts: (user.failed_attempts + 1))
    |> case do
         {:ok, user1} ->
           case user1.failed_attempts >= attempts do
             true ->
               User.update(user1, blocked: true)
               |> case  do
                    {:ok, _} -> user_logs(conn, params["username"], user.id, user.email, "LogIn Failed: User Disabled", "User Blocked by System! Contact Administrator for Activation or Try Again Tomorrow")
                  end
             false -> user_logs(conn, params["username"], user.id, user.email, "LogIn Failed: Invalid Password", "Invalid Username/Password! Attempts: #{user1.failed_attempts}/#{attempts}")
           end
       end
  end

  defp user_logs(conn, username, user_id, reference, reference2, description) do
    Tasks.Service.System.Logs.index(conn, username, "LOGIN ATTEMPT", "USER LOGIN", user_id, reference, reference2, description)
    |> case do
         {:ok, _} ->
           Plug.Conn.configure_session(conn, drop: true)
           {:error, description}
       end
  end

  def attempts() do
    schema = (fn schema  ->
      case Repo.one(schema) do
        nil -> 3
        data -> data
      end
              end)
    schema.(Tasks.Database.Table.Login)
  end

end