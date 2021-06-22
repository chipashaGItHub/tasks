defmodule Tasks.Service.ForgotPassword do
  use TasksWeb, :universal

  def recover(conn, params) do
    multiple = Ecto.Multi.new()
    password = params["password"] |> Rand.randomizer(8)
    recover = (fn (struct, map, schema) -> Repo.transaction(multiple, Ecto.Multi.update(:update, Ecto.Changeset.change(struct, map))) end)
    case User.find_by(username: params["username"]) do
      nil -> recover.(User.find_by(username: params["username"]), %{auto_password: true, password: Tasks.Hash.hash("#{params["username"]}#{password}")})
    end
  end
  
end