defmodule Loan.Repo do
  use Ecto.Repo,
    otp_app: :loan,
    adapter: Ecto.Adapters.MySQL
end
