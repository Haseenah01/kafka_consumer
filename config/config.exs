# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :kafka_consumer,
  ecto_repos: [KafkaConsumer.Repo]

# Configures the endpoint
config :kafka_consumer, KafkaConsumerWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: KafkaConsumerWeb.ErrorHTML, json: KafkaConsumerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: KafkaConsumer.PubSub,
  live_view: [signing_salt: "Q0ZELS83"]


  config :kaffe,
  consumer: [
    # heroku_kafka_env: true,
    endpoints: [{'13.40.7.67', 9092}],
    topics: ["kafka-topic-test"],
    consumer_group: "consumer-group",
    message_handler: KafkaConsumer.Kaffe.MessageProcessor,
    offset_reset_policy: :reset_to_latest,
    max_bytes: 10_000_000,
    worker_allocation_strategy: :worker_per_topic_partition,
    max_poll_records: 500,
    fetch_min_bytes: 5_000,
    num_workers: 10  # Increase the number of workers to process messages
  ]
# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :kafka_consumer, KafkaConsumer.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :logger,
  backends: [:console, {LoggerFileBackend, :file_log}],
  format: "$time $metadata[$level] $message\n",
  metadata: :all

config :logger, :file_log,
  path: "file.log",
  level: :info

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
