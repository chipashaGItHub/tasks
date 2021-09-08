defmodule Tasks.Service.Emails do
  use TasksWeb, :universal

  def insert(changeset) do
    multiple = Ecto.Multi.new()
    try do
      multiple
      |> Multi.insert(:message, changeset)
      |> Repo.transaction()
      |> case do
           {:ok, ok} -> {:ok, ok}
           {:error, error} -> {:error, error}
         end
    rescue
      _->
        Multi.new()
        |> Multi.insert(:failed, changeset)
        |> Repo.transaction()
        |> case do
             {:ok, ok} -> {:ok, ok}
             {:error, error} -> {:error, error}
           end
    end
  end

end