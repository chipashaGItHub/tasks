defmodule Tasks.Database.Schema.User do
  use TasksWeb, :universal

  @db_columns [:id, :username, :password, :status, :email, :status, :first_name, :last_name, :mobile,
    :deleted_at, :user_role, :failed_attempts, :blocked, :last_login_date, :auto_password]
  @timestamps_opts [autogenerate: {Tasks.Utility, :autogenerate, []}]

  @doc """
    schema definition
  """

    schema "users" do
      field :username, :string
      field :password, :string
      field :status, :boolean, default: true
      field :email, :string
      field :is_superUser, :boolean, default: false
      field :mobile, :string
      field :first_name, :string
      field :last_name, :string
      field :deleted_at, :naive_datetime
      field :user_role, :integer
      field :failed_attempts, :integer,  default: 0
      field :blocked, :boolean
      field :last_login_date, :naive_datetime
      field :auto_password, :boolean, default: false


      timestamps(inserted_at: :created_at)
    end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @db_columns)
    |> unique_constraint(:username)
    |> validate_required(:username)
  end


end