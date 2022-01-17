# frozen_string_literal: true

require "application_system_test_case"

class GametournamentsTest < ApplicationSystemTestCase
  setup do
    @game_tournament = game_tournaments(:one)
  end

  test "visiting the index" do
    visit game_tournaments_url
    assert_selector "h1", text: "Game tournaments"
  end

  test "creating a Game tournament" do
    visit game_tournaments_url
    click_on "New Game tournament"

    fill_in "Finalist", with: @game_tournament.finalist_id
    fill_in "Name", with: @game_tournament.name
    fill_in "Status", with: @game_tournament.status
    fill_in "Winner", with: @game_tournament.winner_id
    click_on "Create Game tournament"

    assert_text "Game tournament was successfully created"
    click_on "Back"
  end

  test "updating a Game tournament" do
    visit game_tournaments_url
    click_on "Edit", match: :first

    fill_in "Finalist", with: @game_tournament.finalist_id
    fill_in "Name", with: @game_tournament.name
    fill_in "Status", with: @game_tournament.status
    fill_in "Winner", with: @game_tournament.winner_id
    click_on "Update Game tournament"

    assert_text "Game tournament was successfully updated"
    click_on "Back"
  end

  test "destroying a Game tournament" do
    visit game_tournaments_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Game tournament was successfully destroyed"
  end
end
