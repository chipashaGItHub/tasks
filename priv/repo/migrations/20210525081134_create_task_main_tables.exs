defmodule Tasks.Repo.Migrations.CreateTaskMainTables do
  use Ecto.Migration

  def up do
    create_tables()
  end

  def down do
    drop_tables()
  end

  def create_tables do

    create_if_not_exists table(:users) do
      add :username, :string
      add :password, :string
      add :status, :boolean, default: true
      add :email, :string
      add :is_superUser, :boolean, default: false
      add :mobile, :string
      add :first_name, :string
      add :last_name, :string
      add :deleted_at, :naive_datetime
      add :user_role, :integer
      add :failed_attempts, :integer,  default: 0
      add :blocked, :boolean
      add :last_login_date, :naive_datetime
      add :auto_password, :boolean, default: true

      timestamps(inserted_at: :created_at, type: :utc_datetime)
    end

    create_if_not_exists table(:logs) do
      add :narration, :string
      add :reference2, :string
      add :username, :string
      add :ip_address, :string
      add :actionType, :string
      add :reference, :string
      add :user_id, :integer
      add :description, :string

      timestamps(inserted_at: :created_at, type: :utc_datetime)
    end

    create_if_not_exists table(:emails) do
      add :message, :string
      add :status, :string, default: "PENDING"
      add :deleted_at, :naive_datetime
      add :email, :string
      add :responseCode, :integer
      add :email_count, :integer
      add :date_sent, :naive_datetime
      add :dataResponse, :string

      timestamps(inserted_at: :created_at, type: :utc_datetime)
    end

    create_if_not_exists table(:roles) do
      add :user_id, :integer
      add :role, :string

      timestamps(inserted_at: :created_at, type: :utc_datetime)
    end

  end


  def drop_tables do
    #    drop_if_exists table(:users)
    #    drop_if_exists table(:logs)
    #    drop_if_exists table(:emails)
    #    drop_if_exists table(:roles)
  end
end
