defmodule Sma.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SmaWeb.Telemetry,
      Sma.Repo,
      {DNSCluster, query: Application.get_env(:sma, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Sma.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Sma.Finch},
      # Start a worker by calling: Sma.Worker.start_link(arg)
      # {Sma.Worker, arg},
      # Start to serve requests, typically the last entry
      SmaWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sma.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SmaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
