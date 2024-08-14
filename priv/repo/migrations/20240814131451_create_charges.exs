defmodule KafkaConsumer.Repo.Migrations.CreateCharges do
  use Ecto.Migration

  def change do
    create table(:charges, primary_key: false) do
      add :id, :bytea, primary_key: true
      add :allocated_cost, :decimal
      add :uncharged, :decimal
      add :allocated_qty, :integer
      add :applies_to, :map
      add :c_id, :string
      add :charged_for, :string
      add :charged_to, {:array, :map}
      add :connection_surcharge, :decimal
      add :cost, :decimal
      add :cr_id, :string
      add :description, :string
      add :end_time, :utc_datetime
      add :item_seq_num, :integer
      add :meta, :map
      add :post_surcharge, :decimal
      add :primary_service, :string
      add :quantity, :integer
      add :rating_group, :integer
      add :requestor_node_id, :string
      add :requestor_service_id, :string
      add :rg_meta, :map
      add :rounding_policy, :string
      add :start_time, :utc_datetime
      add :status, :integer
      add :sub_id, :string
      add :tariff_plan, :string
      add :taxes, :map
      add :timestamp, :utc_datetime
      add :tp_meta, :map
      add :type, :integer
      add :unit, :map
      add :unit_rate, :decimal
      add :error, :map
      add :service_id, :uuid

      timestamps()
    end
  end
end
