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
    Application.get_env(:fll_event_livetext, :qlab)[:targets]
    |> Enum.each(fn(target) ->
        {addr, ltext, rtext} = target

        {name_cue, number_cue} =
          case side do
            "blue" -> {ltext.name, ltext.number}
            "red" -> {rtext.name, rtext.number}
            _ -> {nil, nil}
          end

        if number_cue do
          send_cue(addr, name_cue, Roster.team_name(team))
          send_cue(addr, number_cue, Roster.team_number(team))
        else
          send_cue(addr, name_cue, "#{Roster.team_number(team)} #{Roster.team_name(team)}")
        end
      end)

    {:noreply, state}
  end

  defp send_cue(addr, cue, text) do
    with socket <- Socket.UDP.open!,
         :ok <- Socket.Datagram.send(socket, "/cue/#{cue}/liveText \"#{text}\"", addr),
         :ok <- Socket.close(socket)
    do
    end
  end
end
