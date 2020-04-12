defmodule TestProject.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    Picam.Camera.start_link
    opts = [strategy: :one_for_one, name: TestProject.Supervisor]
    children =
      [
        # Children for all targets
        # Starts a worker by calling: TestProject.Worker.start_link(arg)
        # {TestProject.Worker, arg},
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: TestProject.Worker.start_link(arg)
      # {TestProject.Worker, arg},
    ]
  end

  def children(_target) do
    [
      Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: NervesRpi3WifiPicam.Router, options: [port: 4001])
      # Children for all targets except host
      # Starts a worker by calling: TestProject.Worker.start_link(arg)
      # {TestProject.Worker, arg},
    ]
  end

  def target() do
    Application.get_env(:test_project, :target)
  end
end
