# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :loan,
  ecto_repos: [Loan.Repo]

config :loan, Loan.Worker,
  jobs: [
    # Every minute
    {"* * * * *",       {Loan.Automation, :penalty_automation, []}} #,
    # {"* * * * *",       fn -> IO.puts("automation") end} #,
    # Every 15 minutes
    # {"*/15 * * * *",   fn -> System.cmd("rm", ["/tmp/tmp_"]) end},
    # # Runs on 18, 20, 22, 0, 2, 4, 6:
    # {"0 18-6/2 * * *", fn -> :mnesia.backup('/var/backup/mnesia') end},
    # # Runs every midnight:
    # {"@daily",         {Backup, :backup, []}}
  ],
  debug_logging: false

# Configures the endpoint
config :loan, LoanWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7dAIx5DQAe2ZQWUO7dJIKsiIGbigcs5tNw1qarEU65dwTgYf+LbZqN4xhk4NnQ30",
  render_errors: [view: LoanWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Loan.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
