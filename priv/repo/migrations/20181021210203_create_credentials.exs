defmodule Loan.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do
    create table(:credentials) do
      add :username, :string
      add :password, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:credentials, [:username])
    create index(:credentials, [:user_id])
  end
end
