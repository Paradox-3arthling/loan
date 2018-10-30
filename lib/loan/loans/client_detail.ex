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
    # field :user_id, :id
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(client_detail, attrs) do
    client_detail
    |> cast(attrs, [:registration_number, :name, :paydate, :principal_amount, :rate, :penalties])
    |> validate_required([:registration_number, :name, :paydate, :principal_amount, :rate, :penalties])
    |> unique_constraint(:registration_number)
  end
end
