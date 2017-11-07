defmodule FllEventLivetext.Qlab.Supervisor do
  use Supervisor

  alias FllEventLivetext.Qlab.Worker

  def init(_) do
    children = [
      {Worker, %{}},
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end
end
