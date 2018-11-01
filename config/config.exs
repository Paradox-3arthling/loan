# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :loan,
  ecto_repos: [Loan.Repo]

# Configures the endpoint
config :loan, LoanWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ADUOGunqaFTJjkdUji87fM1UBO+qUpZsiYtn1c2nyUArBYbEYg7sIv+KZSxd/h6h",
  render_errors: [view: LoanWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Loan.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
