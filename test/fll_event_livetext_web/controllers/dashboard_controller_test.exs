defmodule FllEventLivetextWeb.PageControllerTest do
  use FllEventLivetextWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Teams"
    assert html_response(conn, 200) =~ "Matches"
  end
end
