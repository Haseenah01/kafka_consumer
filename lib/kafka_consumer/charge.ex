defmodule KafkaConsumer.Charge do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary,  autogenerate: false}
  # @foreign_key_type :binary
  schema "charges" do
    field :cost, :decimal
    field :quantity, :integer
    field :cr_id, :string
    field :c_id, :string
    field :taxes, :map
    field :requestor_service_id, :string
    field :tp_meta, :map
    field :unit, :map
    field :applies_to, :map
    field :charged_to, {:array, :map}
    field :rg_meta, :map
    field :status, :integer
    field :meta, :map
    field :error, :map
    field :requestor_node_id, :string
    field :sub_id, :string
    field :rounding_policy, :string
    field :allocated_qty, :integer
    field :timestamp, :utc_datetime
    field :charged_for, :string
    field :allocated_cost, :decimal
    field :post_surcharge, :decimal
    field :unit_rate, :decimal
    field :service_id, Ecto.UUID
    field :rating_group, :integer
    field :description, :string
    field :primary_service, :string
    field :start_time, :utc_datetime
    field :type, :integer
    field :item_seq_num, :integer
    field :end_time, :utc_datetime
    # field :id, :binary
    field :uncharged, :decimal
    field :connection_surcharge, :decimal
    field :tariff_plan, :string

    timestamps()
  end

  @doc false
  def changeset(charge, attrs) do
    charge
    |> cast(attrs, [:id, :allocated_cost, :uncharged, :allocated_qty, :applies_to, :c_id, :charged_for, :charged_to, :connection_surcharge, :cost, :cr_id, :description, :end_time, :item_seq_num, :meta, :post_surcharge, :primary_service, :quantity, :rating_group, :requestor_node_id, :requestor_service_id, :rg_meta, :rounding_policy, :start_time, :status, :sub_id, :tariff_plan, :taxes, :timestamp, :tp_meta, :type, :unit, :unit_rate, :error, :service_id])
    # |> validate_required([:id, :allocated_cost, :uncharged, :allocated_qty, :c_id, :charged_for, :connection_surcharge, :cost, :cr_id, :description, :end_time, :item_seq_num, :post_surcharge, :primary_service, :quantity, :rating_group, :requestor_node_id, :requestor_service_id, :rounding_policy, :start_time, :status, :sub_id, :tariff_plan, :timestamp, :type, :unit_rate, :service_id])
  end
end
