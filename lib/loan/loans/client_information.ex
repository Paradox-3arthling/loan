defmodule Loan.Loans.ClientInformation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Loan.Loans.ClientDetail
  alias Loan.Accounts.User

  schema "client_information" do
    field :amount, :decimal
    # field :amount_remaining, :decimal
    field :credit_amount, :decimal
    field :debit_amount, :decimal
    field :payment_type, :string
    belongs_to :user, User
    belongs_to :client_detail, ClientDetail
    # field :user_id, :id
    # field :client_id, :id

    timestamps()
  end

  @doc false
  def changeset(client_information, attrs) do
    client_information
    |> cast(attrs, [:client_detail_id, :user_id, :payment_type, :amount, :credit_amount, :debit_amount])
    |> validate_required([:payment_type, :amount])
  end
end
