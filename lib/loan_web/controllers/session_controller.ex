defmodule LoanWeb.SessionController do
  use LoanWeb, :controller

  alias Loan.Accounts

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"username" => username, "password" => password}}) do
    case Accounts.authenticate_by_username_password(username, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: "/client_details")
      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Bad email/password combination")
        |> redirect(to: session_path(conn, :new))
    end
  end

  def delete(conn, _) do
    # configure_session(conn, drop: true)
    conn
    |> configure_session(drop: true)
    # |> put_flash(:info, "Good Bye!")
    |> redirect(to: session_path(conn, :new))
  end
end
