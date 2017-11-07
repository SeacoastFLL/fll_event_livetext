defmodule FllEventLivetext.Qlab do
  use GenServer

  alias FllEventLivetext.Qlab.Worker

  def update(team, side) when is_tuple(team) and is_binary(side) do
    Worker.update(team, side)
  end
end
