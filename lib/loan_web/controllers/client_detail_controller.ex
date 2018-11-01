defmodule LoanWeb.ClientDetailController do
  use LoanWeb, :controller

  require Logger

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
    id = get_session(conn, :user_id)

    {year,""} = Integer.parse( client_detail_params["paydate"]["year"] )
    {month,""} = Integer.parse( client_detail_params["paydate"]["month"] )
    {day,""} = Integer.parse(  client_detail_params["paydate"]["day"] )

    {:ok, date} = Date.new(year, month, day)
    date = Date.add(date, 30)

    {rate,""} = Float.parse( Map.get(client_detail_params, "rate") )
    {principal_amount,""} = Float.parse( Map.get(client_detail_params, "principal_amount") )

    interest = principal_amount *  rate / 100
    total_amount = principal_amount + interest

    Logger.info "--------------------------"
    Logger.info "hello #{inspect(client_detail_params)}"
    # %{map | "in" => "two"}  # for updating maps
    client_detail_params = Map.put(client_detail_params, "interest", interest)
    client_detail_params = Map.put(client_detail_params, "total", total_amount)
    client_detail_params = put_in client_detail_params["paydate"]["day"], date.day
    client_detail_params = put_in client_detail_params["paydate"]["month"], date.month
    client_detail_params = put_in client_detail_params["paydate"]["year"], date.year
    # client_detail_params = put_in client_detail_params, 31

    Logger.info "--------------------------"
    Logger.info "day #{inspect(date.day)}"
    Logger.info "month #{inspect(date.month)}"
    Logger.info "year #{inspect(date.year)} %"
    Logger.info "--------------------------"
    Logger.info "interest: #{inspect(interest)} %"
    Logger.info "--------------------------"
    Logger.info "total_amount: #{inspect(total_amount)} %"
    Logger.info "--------------------------"
    case Loans.create_client_detail(id, client_detail_params) do
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

  def show_payment_page(conn, %{"id" => id}) do
    client_detail = Loans.get_client_detail!(id)
    changeset = Loans.change_client_detail(client_detail)
    render(conn, "pay.html", client_detail: client_detail, changeset: changeset)
  end

  def update_payment(conn, %{"id" => id, "client_detail" => client_detail_params}) do
    client_detail = Loans.get_client_detail!(id)
    # changeset = Loans.change_client_detail(client_detail)

    total = Decimal.to_float(client_detail.total)
    total_db = Decimal.to_float(client_detail.total)
    total_payment = Decimal.to_float(client_detail.total_paid)
    {payment, ""} = Float.parse(client_detail_params["paid"])
    total = total - payment
    total_payment = total_payment + payment
    ################################
    client_detail_params = Map.put(client_detail_params, "total", total)
    client_detail_params = Map.put(client_detail_params, "total_payment", total_payment)

    Logger.info "--------------------------"
    Logger.info "total payment #{inspect(client_detail_params)}"
    Logger.info "--------------------------"
    Logger.info "total #{inspect(client_detail)}"
    Logger.info "--------------------------"
    Logger.info "payment #{inspect(payment)}"
    Logger.info "--------------------------"

    ################################
    # if total < 0 do
    # Logger.info "payment #{inspect(payment)}"
    # Logger.info "--------------------------"
    #   conn
    #   |> put_flash(:error, "Login required")
    #   |> redirect(to: "/client_details/pay/#{id}")
    #   |> halt()
    #   # conn
    #   # |> put_flash(:error, "The client is overpaying")
    #   # # |> render("pay.html", client_detail: client_detail, changeset: changeset)
    #   # |> halt()
    # end
    case Loans.update_client_payment(client_detail, client_detail_params, total_db) do
      {:ok, client_detail} ->
        conn
        |> put_flash(:info, "Client payment successfully paid.")
        |> put_layout("app.html")
        |> redirect(to: client_detail_path(conn, :show, client_detail))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "pay.html", client_detail: client_detail, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "client_detail" => client_detail_params}) do
    client_detail = Loans.get_client_detail!(id)

################################
Logger.info "--------------------------"
Logger.info "hello #{inspect(client_detail_params)}"

{rate, ""} = Float.parse( Map.get(client_detail_params, "rate") )
{principal_amount, ""} = Float.parse( Map.get(client_detail_params, "principal_amount") )
# {paid, ""} = Float.parse( Map.get(client_detail_params, "paid") )
interest = principal_amount *  rate / 100
total_amount = principal_amount + interest

# %{map | "in" => "two"}  # for updating maps
client_detail_params = Map.put(client_detail_params, "interest", interest)
client_detail_params = Map.put(client_detail_params, "total", total_amount)
# client_detail_params = put_in client_detail_params, 31
# users = put_in users[:john].age, 31
Logger.info "--------------------------"
Logger.info "hello #{inspect(client_detail_params)}"
Logger.info "--------------------------"
Logger.info "principal_amount #{inspect(principal_amount)}"
Logger.info "--------------------------"
Logger.info "rate #{inspect(rate)} %"
Logger.info "--------------------------" #
Logger.info "interest: #{inspect(interest)} %"
Logger.info "--------------------------" # %{map | 2 => "two"}
Logger.info "total_amount: #{inspect(total_amount)} %"
Logger.info "--------------------------" # %{map | 2 => "two"}
#################################
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
