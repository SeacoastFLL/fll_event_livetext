defmodule FllEventLivetext.Roster.Worker do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def list do
    GenServer.call(__MODULE__, {:list})
  end

  def set(number, name) when is_number(number) and is_binary(name) do
    GenServer.call(__MODULE__, {:set, number, name})
  end

  def get(number) when is_number(number) do
    GenServer.call(__MODULE__, {:get, number})
  end

  def flush_table do
    GenServer.call(__MODULE__, {:flush_table})
  end

  ## Callbacks ########################################################

  def init(args) do
    {:ok, %{table: args.table}}
  end

  def handle_call({:list}, _from, state) do
    teams =
      :ets.tab2list(state.table)
      |> Enum.sort(fn(a, b) -> elem(a, 0) <= elem(b, 0) end)

    {:reply, teams, state}
  end

  def handle_call({:set, number, name}, _from, state) do
    :ets.insert(state.table, {number, name})

    {:reply, :ok, state}
  end

  def handle_call({:get, number}, _from, state) do
    case :ets.lookup(state.table, number) do
      [{^number, name}] ->
        {:reply, {:ok, name}, state}
      _ ->
        {:reply, {:error, "No team name for #{number}"}, state}
    end
  end

  def handle_call({:flush_table}, _from, state) do
    :ets.delete_all_objects(state.table)

    {:reply, :ok, state}
  end
end
