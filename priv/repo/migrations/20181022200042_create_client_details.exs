defmodule Loan.Repo.Migrations.CreateClientDetails do
  use Ecto.Migration

  def change do
    create table(:client_details) do
      add :registration_number, :string
      add :name, :string
      add :identification_number, :string, default: ""
      add :mobile_number, :string, default: ""
      add :paydate, :date
      add :principal_amount, :decimal, default: 0
      add :interest, :decimal, default: 0
      add :total, :decimal, default: 0
      add :guarantor, :string, default: ""
      add :residence, :string, default: ""
      add :day_not_paid, :decimal, default: 0
      add :rate, :decimal, default: 0
      add :penalties, :decimal, default: 0
      add :active, :boolean, default: true
      add :total_paid, :decimal, default: 0
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:client_details, [:registration_number])
    create index(:client_details, [:user_id])
  end
end
