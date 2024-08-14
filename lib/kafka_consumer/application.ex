defmodule KafkaConsumer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      KafkaConsumerWeb.Telemetry,
      # Start the Ecto repository
      KafkaConsumer.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: KafkaConsumer.PubSub},
      # Start Finch
      {Finch, name: KafkaConsumer.Finch},
      # Start the Endpoint (http/https)
      KafkaConsumerWeb.Endpoint,

      %{
        id: Kaffe.GroupMemberSupervisor,
        start: {Kaffe.GroupMemberSupervisor, :start_link, []},
        type: :supervisor
      },
      Supervisor.Spec.worker(Kaffe.Consumer, [])
      # Start a worker by calling: KafkaConsumer.Worker.start_link(arg)
      # {KafkaConsumer.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KafkaConsumer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KafkaConsumerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
