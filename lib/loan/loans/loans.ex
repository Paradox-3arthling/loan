defmodule Loan.Loans do
  @moduledoc """
  The Loans context.
  """

  import Ecto.Query, warn: false
  alias Loan.Repo

  # alias Loan.Accounts.User
  alias Loan.Loans.{ClientDetail,ClientInformation}

  @doc """
  Returns the list of client_details.

  ## Examples

      iex> list_client_details()
      [%ClientDetail{}, ...]

  """
  def list_client_details() do
    Repo.all(ClientDetail)
    |> Repo.preload(:user)
    # ClientDetail
    # |> Repo.all()
    # |> Repo.preload(:client_information)

    # Repo.all(from c in ClientDetail,
    #       where: c.user_id == ^user_id)
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
  # def get_client_detail!(id), do: Repo.get!(ClientDetail, id)
  def get_client_detail!(id) do
    ClientDetail
    |> Repo.get!(id)
    |> Repo.preload(client_information: :user)
    |> Repo.preload(:user)
  end
  def get_client_detail(id) do
    ClientDetail
    |> Repo.get(id)
    |> Repo.preload(client_information: :user)
    |> Repo.preload(:user)
  end

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

  def update_client_payment(%ClientDetail{} = client_detail, attrs, total_db) do
    client_detail
    |> ClientDetail.changeset_payment(attrs, total_db)
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


  @doc """
  Returns the list of client_information.

  ## Examples

      iex> list_client_information()
      [%ClientInformation{}, ...]

  """
  def list_client_information do
    Repo.all(ClientInformation)
  end

  @doc """
  Gets a single client_information.

  Raises `Ecto.NoResultsError` if the Client information does not exist.

  ## Examples

      iex> get_client_information!(123)
      %ClientInformation{}

      iex> get_client_information!(456)
      ** (Ecto.NoResultsError)

  """
  def get_client_information!(id), do: Repo.get!(ClientInformation, id)

  @doc """
  Creates a client_information.

  ## Examples

      iex> create_client_information(%{field: value})
      {:ok, %ClientInformation{}}

      iex> create_client_information(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_client_information(attrs \\ %{}) do
    %ClientInformation{}
    |> ClientInformation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a client_information.

  ## Examples

      iex> update_client_information(client_information, %{field: new_value})
      {:ok, %ClientInformation{}}

      iex> update_client_information(client_information, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_client_information(%ClientInformation{} = client_information, attrs) do
    client_information
    |> ClientInformation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ClientInformation.

  ## Examples

      iex> delete_client_information(client_information)
      {:ok, %ClientInformation{}}

      iex> delete_client_information(client_information)
      {:error, %Ecto.Changeset{}}

  """
  def delete_client_information(%ClientInformation{} = client_information) do
    Repo.delete(client_information)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking client_information changes.

  ## Examples

      iex> change_client_information(client_information)
      %Ecto.Changeset{source: %ClientInformation{}}

  """
  def change_client_information(%ClientInformation{} = client_information) do
    ClientInformation.changeset(client_information, %{})
  end
end
