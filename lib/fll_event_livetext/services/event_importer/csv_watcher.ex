defmodule FllEventLivetext.EventImporter.CsvWatcher do
  use GenServer

  alias FllEventLivetext.EventImporter

  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  #### Callbacks ########################################################

  def init(args) do
    csv_path = Keyword.get(args, :csv_path, Path.join([File.cwd!, "config", "event.csv"]))

    {:ok, pid} = FileSystem.start_link(dirs: [csv_path])
    FileSystem.subscribe(pid)

    {:ok, %{watcher: pid}}
  end

  def handle_info({:file_event, _from, {path, events}}, %{watcher: _pid} = state) do
    if Enum.member?(events, :modified) || Enum.member?(events, :created) do
      Logger.info("Event CSV updated")
      with {:ok, {teams, matches}} <- EventImporter.parse_csv(path),
           :ok <- EventImporter.reset(),
           :ok <- EventImporter.import_teams(teams),
           :ok <- EventImporter.import_matches(matches)
      do
        Logger.info("Imported #{Enum.count(teams)} teams and #{Enum.count(matches)} matches")
      else
        _ -> Logger.error("Import failed")
      end
    end

    {:noreply, state}
  end

  def handle_info({:file_event, _from, :stop}, %{watcher: _pid} = state) do

    {:noreply, state}
  end
end

