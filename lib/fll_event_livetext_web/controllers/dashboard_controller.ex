defmodule FllEventLivetextWeb.DashboardController do
  use FllEventLivetextWeb, :controller

  alias FllEventLivetext.Roster
  alias FllEventLivetext.Matches

  def index(conn, _params) do
    teams = Roster.list()
    matches =
      Matches.list()
      |> Enum.map(&elem(&1, 1))

    render conn, "index.html", teams: teams, matches: matches
  end
end
