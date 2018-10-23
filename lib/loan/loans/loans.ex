defmodule Loan.Loans do
  @moduledoc """
  The Loans context.
  """

  import Ecto.Query, warn: false
  alias Loan.Repo

  alias Loan.Loans.ClientDetail

  @doc """
  Returns the list of client_details.

  ## Examples

      iex> list_client_details()
      [%ClientDetail{}, ...]

  """
  def list_client_details(user_id) do
    # Repo.all(ClientDetail)

    Repo.all(from c in ClientDetail,
          where: c.user_id == ^user_id)
  end

  @doc """
  Gets a single client_detail.

  Raises `Ecto.NoResultsError` if the Client detail does not exist.

  ## Examples

      iex> get_client_detail!(123)
      %ClientDetail{}

      iex> get_client_detail!(456)
      ** (Ecto.NoResultsError)

  """
  def get_client_detail!(id), do: Repo.get!(ClientDetail, id)

  @doc """
  Creates a client_detail.

  ## Examples

      iex> create_client_detail(%{field: value})
      {:ok, %ClientDetail{}}

      iex> create_client_detail(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_client_detail(id, attrs \\ %{}) do
    %ClientDetail{}
    |> ClientDetail.changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, id)
    |> Ecto.Changeset.put_change(:active, true)
    |> Repo.insert()
  end

  @doc """
  Updates a client_detail.

  ## Examples

      iex> update_client_detail(client_detail, %{field: new_value})
      {:ok, %ClientDetail{}}

      iex> update_client_detail(client_detail, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_client_detail(%ClientDetail{} = client_detail, attrs) do
    client_detail
    |> ClientDetail.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ClientDetail.

  ## Examples

      iex> delete_client_detail(client_detail)
      {:ok, %ClientDetail{}}

      iex> delete_client_detail(client_detail)
      {:error, %Ecto.Changeset{}}

  """
  def delete_client_detail(%ClientDetail{} = client_detail) do
    Repo.delete(client_detail)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking client_detail changes.

  ## Examples

      iex> change_client_detail(client_detail)
      %Ecto.Changeset{source: %ClientDetail{}}

  """
  def change_client_detail(%ClientDetail{} = client_detail) do
    ClientDetail.changeset(client_detail, %{})
  end
end