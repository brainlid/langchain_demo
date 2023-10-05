defmodule LangchainDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: LangchainDemo.TaskSupervisor},
      {DynamicSupervisor, strategy: :one_for_one, name: LangchainDemo.ChatServerSupervisor},
      # Setup for Finch
      {Finch, name: LangchainDemo.OpenAIFinch},
      # Start the Telemetry supervisor
      LangchainDemoWeb.Telemetry,
      # Start the Ecto repository
      LangchainDemo.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: LangchainDemo.PubSub},
      # Start Finch
      {Finch, name: LangchainDemo.Finch},
      # Start the Endpoint (http/https)
      LangchainDemoWeb.Endpoint
      # Start a worker by calling: LangchainDemo.Worker.start_link(arg)
      # {LangchainDemo.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LangchainDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LangchainDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
