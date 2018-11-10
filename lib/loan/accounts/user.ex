defmodule Loan.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Loan.Accounts.Credential


  schema "users" do
    field :email, :string
    field :mobileNo, :string
    field :name, :string
    has_one :credential, Credential

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
