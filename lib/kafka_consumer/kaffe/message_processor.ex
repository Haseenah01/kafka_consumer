defmodule KafkaConsumer.Kaffe.MessageProcessor do
  require Logger
  alias Ecto.Adapters.SQL
  alias KafkaConsumer.Repo

  def handle_message(%{key: key, value: value} = message) do
    Logger.info("Received message: #{key}: #{value}")

    case Jason.decode(value) do
      {:ok, charge_data} ->
        # Construct the SQL query
        sql = """
        INSERT INTO charges (
          id, allocated_cost, uncharged, allocated_qty, applies_to, c_id, charged_for, charged_to,
          connection_surcharge, cost, cr_id, description, end_time, item_seq_num, meta, post_surcharge,
          primary_service, quantity, rating_group, requestor_node_id, requestor_service_id, rg_meta,
          rounding_policy, start_time, status, sub_id, tariff_plan, taxes, timestamp, tp_meta, type,
          unit, unit_rate, error, inserted_at, updated_at, service_id
        ) VALUES (
          $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20,
          $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32, $33, $34, NOW(), NOW(), $35
        )
        """

        # Prepare the parameters for the SQL query
        params = [
          charge_data["id"],
          charge_data["allocated_cost"],
          charge_data["uncharged"] || nil,
          charge_data["allocated_qty"],
          sanitize_jsonb(charge_data["applies_to"]),
          charge_data["c_id"],
          sanitize_jsonb_array(charge_data["charged_to"]),
          charge_data["connection_surcharge"],
          charge_data["cost"],
          charge_data["cr_id"],
          charge_data["description"] || "",
          charge_data["end_time"],
          charge_data["item_seq_num"],
          sanitize_jsonb(charge_data["meta"]),
          charge_data["post_surcharge"],
          charge_data["primary_service"],
          charge_data["quantity"],
          charge_data["rating_group"],
          charge_data["requestor_node_id"],
          charge_data["requestor_service_id"] || "",
          sanitize_jsonb(charge_data["rg_meta"]),
          charge_data["rounding_policy"],
          charge_data["start_time"],
          charge_data["status"],
          charge_data["sub_id"],
          charge_data["tariff_plan"],
          sanitize_jsonb(charge_data["taxes"]),
          charge_data["timestamp"],
          sanitize_jsonb(charge_data["tp_meta"]),
          charge_data["type"],
          sanitize_jsonb(charge_data["unit"]),
          charge_data["unit_rate"],
          charge_data["error"] || "",
          charge_data["service_id"]
        ]

        case SQL.query(Repo, sql, params) do
          {:ok, _result} ->
            Logger.info("Inserted charge successfully")
          {:error, reason} ->
            Logger.error("Failed to insert charge: #{inspect(reason)}")
            # Print the actual query and parameters to debug
            Logger.error("SQL Query: #{sql}")
            Logger.error("Parameters: #{inspect(params)}")
        end

      {:error, reason} ->
        Logger.error("Failed to decode JSON: #{inspect(reason)}")
    end

    :ok
  end

  defp sanitize_jsonb(nil), do: "NULL::jsonb"
  defp sanitize_jsonb(value) when is_map(value) or is_list(value) do
    Jason.encode!(value)
    |> escape_for_sql()
  end
  defp sanitize_jsonb(value) do
    Jason.encode!(value)
    |> escape_for_sql()
  end

  defp sanitize_jsonb_array(nil), do: "NULL::jsonb[]"
  defp sanitize_jsonb_array([]), do: "'{}'::jsonb[]"
  defp sanitize_jsonb_array(json_array) when is_list(json_array) do
    Jason.encode!(json_array)
    |> escape_for_sql()
    |> fn json_string -> "'#{json_string}'::jsonb[]" end.()
  end
  defp sanitize_jsonb_array(_), do: "NULL::jsonb[]"

  defp escape_for_sql(json_string) do
    json_string
    |> String.replace("\\", "\\\\")   # Escape backslashes
    |> String.replace("'", "''")      # Escape single quotes
    |> fn escaped_string -> "'#{escaped_string}'" end.()
  end
end
