defmodule FllEventLivetextWeb.OscController do
  use FllEventLivetextWeb, :controller

  alias FllEventLivetext.Roster
  alias FllEventLivetext.Matches
  alias FllEventLivetext.Qlab

  # PUT /osc/team/:team/:side
  def update(conn, %{"team" => number, "side" => side}) do
    {:ok, team} =
      number
      |> String.to_integer()
      |> Roster.get()

    team
    |> Qlab.update(side)

    redirect(conn, to: dashboard_path(conn, :index))
  end

  # PUT /osc/match/:match
  def update(conn, %{"match" => number}) do
    {:ok, match} =
      number
      |> String.to_integer()
      |> Matches.get()

    {:ok, team} =
      match
      |> Matches.match_red_team()
      |> Roster.get()

    team
    |> Qlab.update("red")

    {:ok, team} =
      match
      |> Matches.match_blue_team()
      |> Roster.get()

    team
    |> Qlab.update("blue")

    redirect(conn, to: dashboard_path(conn, :index))
  end
end
