# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :passwordless_web,
  namespace: PasswordlessWeb

# Configures the endpoint
config :passwordless_web, PasswordlessWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "j3qoV9VUZjZXy3RjdZuIZPgWbTTWr84P0an/V0rjzujnJxUP7/avnGRphC0/mvQY",
  render_errors: [view: PasswordlessWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PasswordlessWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :passwordless_web, :generators,
  context_app: :passwordless

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
