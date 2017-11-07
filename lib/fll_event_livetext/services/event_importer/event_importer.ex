defmodule FllEventLivetext.EventImporter do

  alias NimbleCSV.RFC4180, as: CSV
  alias FllEventLivetext.EventImporter.Worker

  def parse_csv(path) do
    result =
      path
      |> File.stream!
      |> CSV.parse_stream
      |> Enum.reduce(%{state: :start, teams: [], matches: []}, fn(line, acc) ->
        acc =
          case line do
            ["Block Format", "1" | _] -> %{acc | state: :teams}
            ["Block Format", "2" | _] -> %{acc | state: :matches}
            ["Block Format", "3" | _] -> %{acc | state: :done}
            _ -> acc
          end
        case acc.state do
          :teams ->
            number =
              try do
                String.to_integer(Enum.at(line, 0))
              rescue
                ArgumentError -> nil
              end
            if number do
              %{acc | teams: [{number, Enum.at(line, 1)} | acc.teams]}
            else
              acc
            end
          :matches ->
            {match, blue, red} =
              try do
                {
                  String.to_integer(Enum.at(line, 0)),
                  String.to_integer(Enum.at(line, 3)),
                  String.to_integer(Enum.at(line, 4))
                }
              rescue
                ArgumentError -> {nil, nil, nil}
              end
            if match do
              %{acc | matches: [{match, Enum.at(line, 1), Enum.at(line, 2), blue, red} | acc.matches]}
            else
              acc
            end
          _ ->
            acc
        end
      end)

    case result.state do
      :done ->
        {:ok, {Enum.reverse(result.teams), Enum.reverse(result.matches)}}
      _ ->
        {:error, "Failed to parse #{path} (state: #{result.state})"}
    end
  end

  def reset do
    Worker.reset()
  end

  def import_teams(teams) when is_list(teams) do
    Worker.import_teams(teams)
  end

  def import_matches(matches) when is_list(matches) do
    Worker.import_matches(matches)
  end
end
