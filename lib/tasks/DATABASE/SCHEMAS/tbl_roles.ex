defmodule Tasks.Database.Schema.Role do
  use TasksWeb, :universal

  @db_fields [:id, :user, :role]
  @doc """
    schema definition
  """
  schema "roles" do
    field :user_id, :integer
    field :role, :string

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, @db_fields)
    |> unique_constraint(:user)
  end
end