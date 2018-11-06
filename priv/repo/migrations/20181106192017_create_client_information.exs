defmodule Loan.Repo.Migrations.CreateClientInformation do
  use Ecto.Migration

  def change do
    create table(:client_information) do
      add :payment_type, :string, null: false
      add :payment_amount, :decimal, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :client_detail_id, references(:client_details, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:client_information, [:user_id])
    create index(:client_information, [:client_detail_id])
  end
end
