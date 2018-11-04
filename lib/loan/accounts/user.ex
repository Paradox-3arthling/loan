defmodule Loan.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Loan.Accounts.Credential
  alias Loan.Loans.ClientDetail


  schema "users" do
    field :email, :string
    field :mobileNo, :string
    field :name, :string
    has_one :credential, Credential
    has_many :client_detail, ClientDetail

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :mobileNo])
    |> validate_required([:name, :mobileNo])
    |> unique_constraint(:email)
    |> unique_constraint(:mobileNo)
    |> validate_format(:email, ~r/@/)
  end
end
