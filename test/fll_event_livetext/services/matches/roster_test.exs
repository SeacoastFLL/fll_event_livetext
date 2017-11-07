defmodule FllEventLivetext.MatchesTest do
  use ExUnit.Case, async: true

  alias FllEventLivetext.Matches

  @match {1, "10:00 AM", "10:04 AM", 1234, 4321}

  setup do
    Matches.Worker.flush_table()
  end

  describe "list/0" do

    test "returns all matches" do
      Matches.set(@match)
      assert Matches.list == [{1, @match}]
    end

  end

  describe "list/0 (empty)" do

    test "returns no matches" do
      assert Matches.list == []
    end

  end

  describe "get/1" do

    test "returns the match tuple" do
      Matches.set(@match)
      assert Matches.get(1) == {:ok, @match}
    end

  end

  describe "get/1 (non-existent)" do

    test "returns an error" do
      assert Matches.get(1) == {:error, "No match numbered 1"}
    end

  end

  describe "set/2" do

    test "creates a record for the match" do
      assert Matches.get(1) == {:error, "No match numbered 1"}
      Matches.set(@match)
      assert Matches.get(1) == {:ok, @match}
    end

  end

  describe "set/2 (replace)" do

    test "overwrites a record for the match" do
      Matches.set({1, "10:00 PM", "10:04 PM", 5678, 8765})
      assert Matches.get(1) == {:ok, {1, "10:00 PM", "10:04 PM", 5678, 8765}}
      Matches.set(@match)
      assert Matches.get(1) == {:ok, @match}
    end

  end

  describe "flush_table/0" do

    test "removes all team records" do
      Matches.set(@match)
      assert Matches.get(1) == {:ok, @match}
      Matches.flush_table()
      assert Matches.list() == []
    end
  end

  describe "match_number/1" do

    test "returns match number" do
      assert Matches.match_number(@match) == 1
    end
  end

  describe "match_start/1" do

    test "returns match start" do
      assert Matches.match_start(@match) == "10:00 AM"
    end

    test "returns match start (number)" do
      Matches.set(@match)
      assert Matches.match_start(1) == "10:00 AM"
    end
  end

  describe "match_end/1" do

    test "returns match end" do
      assert Matches.match_end(@match) == "10:04 AM"
    end

    test "returns match end (number)" do
      Matches.set(@match)
      assert Matches.match_end(1) == "10:04 AM"
    end
  end

  describe "match_red_team/1" do

    test "returns match red team" do
      assert Matches.match_red_team(@match) == 1234
    end

    test "returns match red team (number)" do
      Matches.set(@match)
      assert Matches.match_red_team(1) == 1234
    end
  end

  describe "match_blue_team/1" do

    test "returns match blue team" do
      assert Matches.match_blue_team(@match) == 4321
    end

    test "returns match blue team (number)" do
      Matches.set(@match)
      assert Matches.match_blue_team(1) == 4321
    end
  end
end
