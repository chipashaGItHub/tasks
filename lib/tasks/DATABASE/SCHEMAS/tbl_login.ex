defmodule Tasks.Database.Table.Login do
  use TasksWeb, :universal

  @moduledoc false

  @db_columns [:attempts, :date_updated, :updated_by]
  @timestamps_opts [autogenerate: {Tasks.Utility, :autogenerate, []}]

  schema "login" do
    field :attempts, :integer
    field :updated_by, :integer
    field :date_updated, :date

    timestamps(inserted_at: :created_at)
  end

  def changeset(login, attrs) do
    login
    |> cast(attrs, @db_columns)
  end


end