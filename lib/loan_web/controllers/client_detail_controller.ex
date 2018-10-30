defmodule LoanWeb.ClientDetailController do
  use LoanWeb, :controller

  # require Logger

  alias Loan.Loans
  alias Loan.Loans.ClientDetail

  def index(conn, _params) do
    client_details = Loans.list_client_details(get_session(conn, :user_id))
    render(conn, "index.html", client_details: client_details)
  end

  def new(conn, _params) do
    changeset = Loans.change_client_detail(%ClientDetail{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"client_detail" => client_detail_params}) do
    # current_user = client_detail_params
    # Logger.info "--------------------------"
    # Logger.info "hello #{inspect(current_user)}"
    # Logger.info "--------------------------"
    case Loans.create_client_detail(get_session(conn, :user_id), client_detail_params) do
      {:ok, client_detail} ->
        conn
        |> put_flash(:info, "Client detail created successfully.")
        |> redirect(to: client_detail_path(conn, :show, client_detail))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    client_detail = Loans.get_client_detail!(id)
    render(conn, "show.html", client_detail: client_detail)
  end

  def edit(conn, %{"id" => id}) do
    client_detail = Loans.get_client_detail!(id)
    changeset = Loans.change_client_detail(client_detail)
    render(conn, "edit.html", client_detail: client_detail, changeset: changeset)
  end

  def update(conn, %{"id" => id, "client_detail" => client_detail_params}) do
    client_detail = Loans.get_client_detail!(id)

    case Loans.update_client_detail(client_detail, client_detail_params) do
      {:ok, client_detail} ->
        conn
        |> put_flash(:info, "Client detail updated successfully.")
        |> redirect(to: client_detail_path(conn, :show, client_detail))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", client_detail: client_detail, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    client_detail = Loans.get_client_detail!(id)
    {:ok, _client_detail} = Loans.delete_client_detail(client_detail)

    conn
    |> put_flash(:info, "Client detail deleted successfully.")
    |> redirect(to: client_detail_path(conn, :index))
  end
end
