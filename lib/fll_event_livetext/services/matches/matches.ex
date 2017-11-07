defmodule FllEventLivetext.Matches do
  use GenServer

  alias FllEventLivetext.Matches.Worker

  def list do
    Worker.list()
  end

  def set(match) when is_tuple(match) do
    Worker.set(match)
  end

  def get(number) when is_integer(number) do
    Worker.get(number)
  end

  def flush_table do
    Worker.flush_table()
  end

  def match_number(match) do
    elem(match, 0)
  end

  def match_start(match) when is_tuple(match) do
    elem(match, 1)
  end

  def match_start(number) when is_integer(number) do
    case get(number) do
      {:ok, match} -> match_start(match)
      _ -> nil
    end
  end

  def match_end(match) when is_tuple(match) do
    elem(match, 2)
  end

  def match_end(number) when is_integer(number) do
    case get(number) do
      {:ok, match} -> match_end(match)
      _ -> nil
    end
  end

  def match_red_team(match) when is_tuple(match) do
    elem(match, 3)
  end

  def match_red_team(number) when is_integer(number) do
    case get(number) do
      {:ok, match} -> match_red_team(match)
      _ -> nil
    end
  end

  def match_blue_team(match) when is_tuple(match) do
    elem(match, 4)
  end

  def match_blue_team(number) when is_integer(number) do
    case get(number) do
      {:ok, match} -> match_blue_team(match)
      _ -> nil
    end
  end
end
