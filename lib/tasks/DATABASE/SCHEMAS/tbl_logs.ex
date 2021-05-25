defmodule Tasks.Database.Schema.AuditLogs do
  use TasksWeb, :universal

  schema "logs" do
    field :narration, :string
    field :reference2, :string
    field :username, :string
    field :ip_address, :string
    field :actionType, :string
    field :reference, :string
    field :user_id, :string
    field :description, :string

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end

end