defmodule Tasks.Database.Schema.Emails do
  use TasksWeb, :universal

  @doc """
    schema definition
  """
  @db_columns [:message, :status, :email, :deleted_at, :responseCode, :email_count, :dataResponse]
  @timestamps_opts [autogenerate: {Tasks.Utility, :autogenerate, []}]

  schema "emails" do
    field :message, :string
    field :status, :string, default: "PENDING"
    field :deleted_at, :naive_datetime
    field :email, :string
    field :responseCode, :integer
    field :email_count, :integer
    field :date_sent, :naive_datetime
    field :dataResponse, :string

    timestamps(inserted_at: :created_at)
  end


  def changeset(email, attrs) do
    email
    |> cast(attrs, @db_columns)
  end

end