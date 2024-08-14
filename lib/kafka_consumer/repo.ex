defmodule KafkaConsumer.Repo do
  use Ecto.Repo,
    otp_app: :kafka_consumer,
    adapter: Ecto.Adapters.Postgres
end
