defmodule FllEventLivetext.Qlab.Worker do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def update(team, side) when is_tuple(team) and is_binary(side) do
    GenServer.cast(__MODULE__, {:update, team, side})
  end

  ## Callbacks ########################################################

  def init(_args) do
    {:ok, %{}}
  end

  def handle_cast({:update, team, side}, state) do

    {:noreply, state}
  end
end
