defmodule LoanWeb.Router do
  use LoanWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LoanWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete],
                                                  singleton: true
  end

  scope "/", LoanWeb do
      pipe_through [:browser, :authenticate_user]

      # resources "/users", UserController, except: [:new, :create]
      resources "/users", UserController
      # post "/client_details/:id", ClientDetailController, :show_payment_page
      resources "/client_details", ClientDetailController
      # delete "/client_details/delete/:id", ClientDetailController, :delete_client
      put "/client_details/pay/:id", ClientDetailController, :update_payment
      get "/client_details/pay/:id", ClientDetailController, :show_payment_page
  end
  # Other scopes may use custom stacks.
  # scope "/api", LoanWeb do
  #   pipe_through :api
  # end
  defp authenticate_user(conn, _) do
  case get_session(conn, :user_id) do
    nil ->
      conn
      |> Phoenix.Controller.put_flash(:error, "Login required")
      |> Phoenix.Controller.redirect(to: "/sessions/new")
      |> halt()
    user_id ->
      assign(conn, :current_user, Loan.Accounts.get_user!(user_id))
  end
end
end
