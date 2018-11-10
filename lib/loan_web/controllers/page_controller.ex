defmodule LoanWeb.PageController do
  use LoanWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
