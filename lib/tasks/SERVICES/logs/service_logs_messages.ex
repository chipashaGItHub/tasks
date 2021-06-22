defmodule Tasks.Service.Logs do
  use TasksWeb, :universal

  def message(message, email) do
    try do
      Multi.new()
      |> Multi.insert(:message, %Emails{message: message, status: "PENDING", email: email})
      |> Repo.transaction()
      |> case do
           {:ok, _} -> {:ok, :error}
           {:error, _} -> {:ok, :error}
         end
    rescue
      _->
        Multi.new()
        |> Multi.insert(:failed, %Emails{message: "Failed to insert Email", status: "FAILED", email: email})
        |> Repo.transaction()
        |> case do
             {:ok, _} -> {:ok, :error}
             {:error, _} -> {:ok, :error}
           end
    end
  end

end