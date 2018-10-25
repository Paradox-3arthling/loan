defmodule Loan.Loans.ClientDetail do
  use Ecto.Schema
  import Ecto.Changeset
  alias Loan.Accounts.User


  schema "client_details" do
    field :active, :boolean, default: false
    field :day_not_paid, :decimal
    field :guarantor, :string
    field :identification_number, :string
    field :interest, :decimal
    field :mobile_number, :string
    field :name, :string
    field :paydate, :date
    field :penalties, :decimal
    field :principal_amount, :decimal
    field :rate, :decimal
    field :registration_number, :string
    field :residence, :string
    field :total, :decimal
    field :total_paid, :decimal
    field :initial_total_paid, :decimal
    belongs_to :user, User
    field :paid, :decimal, virtual: true

    timestamps()
  end

  @doc false
  def changeset(client_detail, attrs) do
    client_detail
    |> cast(attrs, [:initial_total_paid, :registration_number, :name, :paydate, :principal_amount, :rate, :paid, :total_paid, :penalties, :total, :residence, :mobile_number, :interest, :active, :day_not_paid, :guarantor, :identification_number])
    # |> validate_required([:registration_number, :name, :paydate, :principal_amount, :rate, :paid, :total_paid, :penalties, :total, :residence, :mobile_number, :interest, :active, :day_not_paid, :guarantor, :identification_number])
    |> validate_required([:registration_number, :name, :paydate, :principal_amount, :rate, :penalties])
    |> validate_number(:principal_amount, greater_than: 0)
    |> validate_number(:rate, greater_than: 0)
    |> validate_number(:rate, less_than: 100)
    |> validate_number(:penalties, greater_than: 0)
    |> unique_constraint(:registration_number)
  end

  @doc false
  def changeset_update(client_detail, attrs) do
    client_detail
    |> cast(attrs, [:residence, :mobile_number, :guarantor, :identification_number])
    |> validate_required([:residence, :mobile_number, :guarantor, :identification_number])
  end
  @doc false
  def changeset_payment(client_detail, attrs, total) do
    total = total + 0.0001
    client_detail
    |> cast(attrs, [:paid, :total_paid, :total])
    |> validate_required([:paid])
    |> validate_number(:paid, less_than: total)
    |> validate_number(:paid, greater_than: 0)
  end
end
