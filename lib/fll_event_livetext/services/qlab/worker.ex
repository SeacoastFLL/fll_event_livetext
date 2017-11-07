defmodule FllEventLivetext.Qlab.Worker do
  use GenServer

  alias FllEventLivetext.Roster

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
    addrs = Application.get_env(:fll_event_livetext, :qlab)[:addrs]

    cue =
      case side do
        "red" -> Application.get_env(:fll_event_livetext, :qlab)[:red]
        "blue" -> Application.get_env(:fll_event_livetext, :qlab)[:blue]
        _ -> "none"
      end

    Enum.each(addrs, fn(addr) ->
      with socket <- Socket.UDP.open!,
           :ok <- Socket.Datagram.send(socket, "/cue/#{cue}/liveText \"#{Roster.team_number(team)} #{Roster.team_name(team)}\"", addr),
           :ok <- Socket.close(socket)
      do
      end
    end)

    {:noreply, state}
  end
end
