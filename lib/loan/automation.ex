defmodule Loan.Automation do
  @moduledoc """
    For automation of penalty automation... should be used once a day :)
    """
  use Timex

  alias Loan.Loans
  def penalty_automation() do
    client_detail = Loans.get_late_payment_clients(Timex.now)
    penalize_clients client_detail
    :ok
  end

  defp penalize_clients([client_detail | tail]) do

      #The total number of days the penalty has not been paid
    days_not_paid =  Date.diff(client_detail.paydate, Timex.today)
      #Adding penalties to the total penalties
    total_payable_penalty = Decimal.to_float(client_detail.total_penalty) +  Decimal.to_float(client_detail.penalties)
      #Adding penalties to the monthly payable
    monthly_payable = Decimal.to_float(client_detail.monthly_payable) +  Decimal.to_float(client_detail.penalties)
      #Adding penalties to the total payable
    total_payable = Decimal.to_float(client_detail.total) +  Decimal.to_float(client_detail.penalties)
    #
    # standard_penalty = days_not_paid * Decimal.to_float(client_detail.penalties)
    # if (standard_penalty != Decimal.to_float(client_detail.total_penalty)) and Decimal.to_float(client_detail.total_penalty) != 0 do
    #   IO.puts "client: #{inspect(client_detail.name)}, client_id: #{inspect(client_detail.id)} seems to have off penalty values"
    # else
      client_detail_params = %{"total_penalty" => total_payable_penalty, "day_not_paid" => -days_not_paid, "monthly_payable" => monthly_payable,"total" => total_payable}

      #####Recording the transaction##################
      link_insertion = %{"user_id" => 1, "client_detail_id" => client_detail.id, "payment_type" => "Penalty", "amount" => total_payable, "debit_amount" => 0, "credit_amount" => client_detail.penalties}
      #####Recording the transaction##################

      Loans.update_client_detail(client_detail, client_detail_params)
      Loans.create_client_information(link_insertion)
      IO.puts "processed penalty for: #{inspect(client_detail.name)}"
      IO.puts "Information: #{inspect(client_detail_params)}"
    penalize_clients(tail)
    # [head * 2 | double_each(tail)]
  end

  defp penalize_clients([]) do
    IO.puts "[Automation done]successfully completed automation at #{inspect(Timex.now)}"
    :ok
  end
end
