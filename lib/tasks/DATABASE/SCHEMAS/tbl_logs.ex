defmodule Tasks.Database.Schema.Logs do
  use TasksWeb, :universal

  @db_columns [:narration, :reference2, :username, :actionType, :description, :user_id, :reference]
  @timestamps_opts [autogenerate: {Tasks.Utility, :autogenerate, []}]

  schema "logs" do
    field :narration, :string
    field :reference2, :string
    field :username, :string
    field :ip_address, :string
    field :actionType, :string
    field :reference, :string
    field :user_id, :integer
    field :description, :string

    timestamps(inserted_at: :created_at)
  end

  def changeset(logs, attrs) do
    logs
    |> cast(attrs, @db_columns)
  end

end