defmodule LoanWeb.ClientDetailController do
  use LoanWeb, :controller

  require Logger

  alias Loan.Loans
  alias Loan.Loans.ClientDetail

  def index(conn, _params) do
    client_details = Loans.list_client_details()
      # client_details = Loans.list_client_details(get_session(conn, :user_id))
    if client_details == [] do
      render(conn, "index_blank.html", client_details: client_details)
    else
      render(conn, "index.html", client_details: client_details)
    end
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

    case  Float.parse(client_detail_params["principal_amount"]) do

      {principal_amount,""} ->
        interest = principal_amount *  rate / 100
        total_amount = principal_amount + interest
        random_number = Integer.to_string(:rand.uniform(1000))
        registration_number = client_detail_params["paydate"]["day"] <> "/" <> client_detail_params["paydate"]["month"] <> "/" <> random_number
        # %{map | "in" => "two"}  # for updating maps
        client_detail_params = Map.put(client_detail_params, "interest", interest)
        client_detail_params = put_in client_detail_params["registration_number"], registration_number
        client_detail_params = put_in client_detail_params["total"], total_amount
        client_detail_params = put_in client_detail_params["monthly_payable"], interest
        client_detail_params = put_in client_detail_params["total_without_penalty"], total_amount
        client_detail_params = put_in client_detail_params["initial_total_paid"], total_amount
        client_detail_params = put_in client_detail_params["paydate"]["day"], date.day
        client_detail_params = put_in client_detail_params["paydate"]["month"], date.month
        client_detail_params = put_in client_detail_params["paydate"]["year"], date.year

        case Loans.create_client_detail(id, client_detail_params) do
          {:ok, client_detail} ->
            conn
            |> put_flash(:info, "Client detail created successfully.")
            |> redirect(to: Routes.client_detail_path(conn, :show, client_detail))
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "new.html", changeset: changeset)
        end
      _ ->
      case Loans.create_client_detail(id, client_detail_params) do
        {:ok, client_detail} ->
          conn
          |> put_flash(:info, "Client detail created successfully.")
          |> redirect(to: Routes.client_detail_path(conn, :show, client_detail))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end

    end
  end

  def show(conn, %{"id" => id}) do
    case Loans.get_client_detail(id) do
      nil ->
        conn
        |> put_flash(:info, "Client does not exist")
        |> redirect(to: Routes.client_detail_path(conn, :index))
      client_detail -> render(conn, "show.html", client_detail: client_detail)
    end
  end

  def edit(conn, %{"id" => id}) do
    client_detail = Loans.get_client_detail!(id)
    changeset = Loans.change_client_detail(client_detail)
    render(conn, "edit.html", client_detail: client_detail, changeset: changeset)
  end

  def show_payment_page(conn, %{"id" => id}) do

      case Loans.get_client_detail(id) do
        nil ->
          conn
          |> put_flash(:info, "Client does not exist, so payment wo't be not possible")
          |> redirect(to: Routes.client_detail_path(conn, :index))
        client_detail ->
          changeset = Loans.change_client_detail(client_detail)
          render(conn, "pay.html", client_detail: client_detail, changeset: changeset)
      end
  end

  def update_payment(conn, %{"id" => id, "client_detail" => client_detail_params}) do
    client_detail = Loans.get_client_detail!(id)

    minimum_payment = Decimal.to_float(client_detail.monthly_payable)

    #total = Decimal.to_float(client_detail.total)
    total_db = Decimal.to_float(client_detail.total)
    total_paid = Decimal.to_float(client_detail.total_paid)
    total_without_penalty = Decimal.to_float(client_detail.total_without_penalty)
    penalties = Decimal.to_float(client_detail.total_penalty)
    date = Date.add(client_detail.paydate, 30)
    date_map = %{"day" => Integer.to_string(date.day), "month" => Integer.to_string(date.month), "year" => Integer.to_string(date.year)}

    case  Float.parse(client_detail_params["paid"]) do
        {payment, ""} ->
          #####Recording the transaction##################
          user_id = get_session(conn, :user_id)
          link_insertion = %{"user_id" => user_id, "client_detail_id" => id, "payment_type" => "Payment", "credit_amount" => minimum_payment, "debit_amount" => payment}
          #####Recording the transaction##################

              #Add up the total paid by client
            client_detail_params = Map.put(client_detail_params, "total_paid", total_paid + payment)
            client_detail_params = Map.put(client_detail_params, "monthly_payable", minimum_payment - payment)

            original_payment = payment
              #Then deduct penalty from payment
            payment = payment - penalties

            client_detail_params =
            if payment >= 0 do
                #When penalty are cleared reset it
              client_detail_params
              |> Map.put("total_penalty", 0)
              |> Map.put("total", total_db - penalties)
            else
                #When penalty are NOT cleared just minus the payment
              client_detail_params
              |> Map.put("total_penalty", penalties - original_payment)
              |> Map.put("total", total_db - original_payment)
            end
            current_total = client_detail_params["total"]
              #What is Remaining of the payment to be deducted from monthly payable
            minimum_payment = minimum_payment - (payment + penalties)
            client_detail_params =
            if minimum_payment <= 0 do
              #1)What client has paid for without penalties
              #2)when monthly minimum is paid is when we deduct from total Remaining
            #2[optional] put_in client_detail_params["total"], total - minimum_payment #Incase they need the total to always add up when the total principal is not paiddo
              #3)when monthly minimum is paid we roll over date
              #4)when monthly minimum is paid we reset the monthly payable
              client_detail_params
              |> Map.put("total_without_penalty", total_without_penalty + minimum_payment)
              |> Map.put("total", current_total + minimum_payment)
              |> Map.put("paydate", date_map)
              |> Map.put("day_not_paid", 0)
              |> Map.put("monthly_payable", client_detail.interest)
            else
              client_detail_params
            end
              #Saving final total to keep track of client information :)
          # total = client_detail.total
          link_insertion = Map.put(link_insertion, "amount", client_detail.total)
          link_insertion =
            if payment < 0 || minimum_payment > 0 do
              link_insertion
              |> Map.put("credit_amount", original_payment)
              |> Map.put("payment_type", "Payment(not minimum)")
            else
              link_insertion
            end
##Incase
            # client_detail_params =
            # if penalties <= 0 do
            #   put_in client_detail_params["total_penalty"], 0
            # else
            #   client_detail_params
            #   |> Map.put("monthly_payable", minimum_payment - payment)
            #   |> Map.put("total_penalty", penalties)
            # end
            # client_detail_params =
            # if payment >= minimum_payment do
            #   client_detail_params
            #   |> Map.put("paydate", date_map)
            #   |> Map.put("monthly_payable", client_detail.interest)
            # else
            #   put_in client_detail_params["monthly_payable"], minimum_payment - payment
            # end
##Incase
            ################################
            Logger.info "--------------------------"
            Logger.info "Happy to work for you :)"
            Logger.info "--------------------------"
            ################################
            ################################
            Logger.info "--------------------------"
            Logger.info "link_insertion: #{inspect(link_insertion)}"
            Logger.info "--------------------------"
            ################################

            case Loans.update_client_payment(client_detail, client_detail_params, total_db) do
              {:ok, client_detail} ->
                Loans.create_client_information(link_insertion)
                conn
                |> put_flash(:info, "Client payment successfully procesed!")
                # |> put_layout("app.html")
                |> redirect(to: Routes.client_detail_path(conn, :show, client_detail))
              {:error, %Ecto.Changeset{} = changeset} ->
                render(conn, "pay.html", client_detail: client_detail, changeset: changeset)
            end

        _ ->  Logger.info "No payment given"
        ################################

          case Loans.update_client_payment(client_detail, client_detail_params, total_db) do
            {:ok, client_detail} ->
              conn
              |> put_flash(:info, "Client payment successfully paid.")
              |> put_layout("app.html")
              |> redirect(to: Routes.client_detail_path(conn, :show, client_detail))
            {:error, %Ecto.Changeset{} = changeset} ->
              render(conn, "pay.html", client_detail: client_detail, changeset: changeset)
          end
      end
  end

  def update(conn, %{"id" => id, "client_detail" => client_detail_params}) do
    client_detail = Loans.get_client_detail!(id)

################################
Logger.info "--------------------------"
Logger.info "hello #{inspect(client_detail_params)}"

#################################
    case Loans.update_client_detail_information(client_detail, client_detail_params) do
      {:ok, client_detail} ->
        conn
        |> put_flash(:info, "Client detail updated successfully.")
        |> redirect(to: Routes.client_detail_path(conn, :show, client_detail))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", client_detail: client_detail, changeset: changeset)
    end
  end


  def delete(conn, %{"id" => id}) do
    client_detail = Loans.get_client_detail!(id)
    ################################
    Logger.info "--------------------------"
    Logger.info "hello #{inspect(client_detail)}"
    Logger.info "--------------------------"
    Logger.info "--------------------------"
    Logger.info "hello #{inspect(id)}"

    {:ok, _client_detail} = Loans.delete_client_detail(client_detail)

    conn
    |> put_flash(:info, "Client detail deleted successfully.")
    |> redirect(to: Routes.client_detail_path(conn, :index))
  end
end
