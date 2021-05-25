defmodule Tasks.Database.Schema.Emails do
  use TasksWeb, :universal

  @doc """
    schema definition
  """
  schema "emails" do
    field :message, :string
    field :status, :string, default: "PENDING"
    field :deleted_at, :naive_datetime
    field :receipentMobileNumber, :string
    field :responseCode, :integer
    field :msg_count, :integer
    field :date_sent, :naive_datetime
    field :dataResponse, :string

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end

end