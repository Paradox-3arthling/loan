defmodule Loan.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :mobileNo, :string

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:mobileNo])
  end
end
