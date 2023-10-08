defmodule LangChainDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: LangChainDemo.TaskSupervisor},
      {DynamicSupervisor, strategy: :one_for_one, name: LangChainDemo.ChatServerSupervisor},
      # Setup for Finch
      {Finch, name: LangChainDemo.OpenAIFinch},
      # Start the Telemetry supervisor
      LangChainDemoWeb.Telemetry,
      # Start the Ecto repository
      LangChainDemo.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: LangChainDemo.PubSub},
      # Start Finch
      {Finch, name: LangChainDemo.Finch},
      # Start the Endpoint (http/https)
      LangChainDemoWeb.Endpoint
      # Start a worker by calling: LangChainDemo.Worker.start_link(arg)
      # {LangChainDemo.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LangChainDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LangChainDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
