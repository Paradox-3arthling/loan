defmodule Loan.Worker do
  use Quantum.Scheduler,
    otp_app: :loan
end
