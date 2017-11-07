defmodule FllEventLivetextWeb.DashboardController do
  use FllEventLivetextWeb, :controller

  alias FllEventLivetext.Roster
  alias FllEventLivetext.Matches

  def index(conn, _params) do
    teams = Roster.list()
    matches = Matches.list()

    render conn, "index.html", teams: teams, matches: matches
  end
end
