defmodule FllEventLivetext.Roster do
  use GenServer

  alias FllEventLivetext.Roster.Worker

  def list do
    Worker.list()
  end

  def set(team) when is_tuple(team) do
    Worker.set(team)
  end

  def get(number) when is_number(number) do
    Worker.get(number)
  end

  def flush_table do
    Worker.flush_table()
  end

  def team_number(team) when is_tuple(team) do
    elem(team, 0)
  end

  def team_name(team) when is_tuple(team) do
    elem(team, 1)
  end
end
