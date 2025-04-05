defmodule RestaurantReviewer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RestaurantReviewerWeb.Telemetry,
      RestaurantReviewer.Repo,
      RestaurantReviewer.Repo.USA,
      RestaurantReviewer.Repo.Canada,
      RestaurantReviewer.Repo.Mexico,
      RestaurantReviewer.CountryRepo,
      {DNSCluster, query: Application.get_env(:restaurant_reviewer, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: RestaurantReviewer.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: RestaurantReviewer.Finch},
      # Start a worker by calling: RestaurantReviewer.Worker.start_link(arg)
      # {RestaurantReviewer.Worker, arg},
      # Start to serve requests, typically the last entry
      RestaurantReviewerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RestaurantReviewer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RestaurantReviewerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
