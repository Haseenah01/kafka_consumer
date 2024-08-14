defmodule KafkaConsumer.Kaffe.MessageProcessor do
  require Logger
  alias Ecto.Adapters.SQL
  alias KafkaConsumer.Repo
  alias Timex

  def handle_message(%{key: key, value: value} = message) do
    Logger.info("Received message: #{key}: #{value}")

    case Jason.decode(value) do
    {:ok, charge_data} ->
      changeset = KafkaConsumer.Charge.changeset(%KafkaConsumer.Charge{}, charge_data)

      case Repo.insert(changeset) do
        {:ok, _charge} ->
          Logger.info("Inserted charge successfully")

        {:error, reason} ->
          Logger.error("Failed to insert charge: #{inspect(reason)}")
      end

    {:error, reason} ->
      Logger.error("Failed to decode JSON: #{reason}")
  end

    :ok
  end

end
