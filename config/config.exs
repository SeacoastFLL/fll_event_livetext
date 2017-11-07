# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :fll_event_livetext, FllEventLivetextWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3mwRONg65F+58Sk7g9paOh++/5l71YF5Bgl1PRi+rJItzREmxVZ4bzLakpFfYKg2",
  render_errors: [view: FllEventLivetextWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: FllEventLivetext.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Qlab configuration
config :fll_event_livetext, :qlab,
  addrs: [
    {{127,0,0,1}, 53535}
  ],
  red: "RN",
  blue: "LN"
import_config "qlab*.exs"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
