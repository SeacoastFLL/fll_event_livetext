defmodule FllEventLivetext.EventImporter.Worker do
  use GenServer

  alias FllEventLivetext.Matches
  alias FllEventLivetext.Roster

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def reset do
    GenServer.call(__MODULE__, {:reset})
  end

  def import_teams(teams) when is_list(teams) do
    Enum.each(teams, fn(team) -> import_team(team) end)
  end

  def import_team(team) when is_tuple(team) do
    GenServer.call(__MODULE__, {:import_team, team})
  end

  def import_matches(matches) when is_list(matches) do
    Enum.each(matches, fn(match) -> import_match(match) end)
  end

  def import_match(match) when is_tuple(match) do
    GenServer.call(__MODULE__, {:import_match, match})
  end

  #### Callbacks ########################################################

  def init(_args) do
    {:ok, %{}}
  end

  def handle_call({:reset}, _from, state) do
    with :ok <- Roster.flush_table()
    do
      {:reply, :ok, state}
    else
      {:error, message} ->
        {:reply, {:error, message}, state}
      _ ->
        {:reply, {:error, nil}, state}
    end
  end

  def handle_call({:import_team, team}, _from, state) do
    {:reply, Roster.set(team), state}
  end

  def handle_call({:import_match, match}, _from, state) do
    {:reply, Matches.set(match), state}
  end
end

