defmodule FllEventLivetext.EventImporter.Supervisor do
  use Supervisor

  alias FllEventLivetext.EventImporter.CsvWatcher
  alias FllEventLivetext.EventImporter.Worker

  def init(_) do
    children = [
      {CsvWatcher, []},
      {Worker, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end
end
