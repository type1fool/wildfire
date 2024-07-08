defmodule Wildfire.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @pubsub Wildfire.PubSub

  @impl true
  def start(_type, _args) do
    children = [
      WildfireWeb.Telemetry,
      Wildfire.Repo,
      {Ecto.Migrator,
       repos: Application.fetch_env!(:wildfire, :ecto_repos), skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:wildfire, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: @pubsub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Wildfire.Finch},
      # Start a worker by calling: Wildfire.Worker.start_link(arg)
      # {Wildfire.Worker, arg},
      # Start to serve requests, typically the last entry
      WildfireWeb.Endpoint,
      {Wildfire.Tracker, pubsub_server: @pubsub},
      Wildfire.Fly.Regions
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Wildfire.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WildfireWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
