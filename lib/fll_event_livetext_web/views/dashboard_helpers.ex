defmodule FllEventLivetextWeb.DashboardHelpers do
  use Phoenix.HTML

  alias FllEventLivetext.Roster
  alias FllEventLivetext.Matches

  def team_number(team) when is_tuple(team) do
    Roster.team_number(team)
  end

  def team_name(team) when is_tuple(team) do
    Roster.team_name(team)
  end

  def match_number(match) when is_tuple(match) do
    Matches.match_number(match)
  end

  def match_time(match) when is_tuple(match) do
    "#{Matches.match_start(match)} - #{Matches.match_end(match)}"
  end

  def match_red_team(match) when is_tuple(match) do
    Matches.match_red_team(match)
  end

  def match_blue_team(match) when is_tuple(match) do
    Matches.match_blue_team(match)
  end
end
