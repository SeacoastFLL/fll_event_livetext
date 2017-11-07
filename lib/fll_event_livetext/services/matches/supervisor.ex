defmodule FllEventLivetext.Matches.Supervisor do
  use Supervisor

  alias FllEventLivetext.Matches.Worker

  def init(_) do
    table = :ets.new(:team_roster, [:set, :public])
    children = [
      {Worker, %{table: table}},
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end
end
