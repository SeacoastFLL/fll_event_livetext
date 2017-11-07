defmodule FllEventLivetext.RosterTest do
  use ExUnit.Case, async: true

  alias FllEventLivetext.Roster

  @team {1234, "Team 1234"}

  setup do
    Roster.Worker.flush_table()
  end

  describe "list/0" do

    test "returns all teams on the roster" do
      Roster.set(@team)
      assert Roster.list() == [@team]
    end

  end

  describe "list/0 (empty)" do

    test "returns no teams" do
      assert Roster.list == []
    end

  end

  describe "get/1" do

    test "returns the team name" do
      Roster.set(@team)
      assert Roster.get(1234) == {:ok, @team}
    end

  end

  describe "get/1 (non-existent)" do

    test "returns an error" do
      assert Roster.get(1234) == {:error, "No team name for 1234"}
    end

  end

  describe "set/2" do

    test "creates a record for the team" do
      assert Roster.get(1234) == {:error, "No team name for 1234"}
      Roster.set(@team)
      assert Roster.get(1234) == {:ok, @team}
    end

  end

  describe "set/2 (replace)" do

    test "overwrites a record for the team" do
      Roster.set(@team)
      assert Roster.get(1234) == {:ok, @team}
      Roster.set({1234, "Blind Badgers"})
      assert Roster.get(1234) == {:ok, {1234, "Blind Badgers"}}
    end

  end

  describe "flush_table/0" do

    test "removes all team records" do
      Roster.set(@team)
      assert Roster.get(1234) == {:ok, @team}
      Roster.flush_table()
      assert Roster.list() == []
    end
  end
end
