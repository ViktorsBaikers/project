# frozen_string_literal: true

require 'application_system_test_case'

class GamesTest < ApplicationSystemTestCase
  setup do
    @game = games(:one)
  end

  test 'visiting the index' do
    visit games_url
    assert_selector 'h1', text: 'Games'
  end

  test 'creating a Game' do
    visit games_url
    click_on 'New Game'

    fill_in 'Level', with: @game.level
    fill_in 'Team a', with: @game.team_a
    fill_in 'Team a score', with: @game.team_a_score
    fill_in 'Team b', with: @game.team_b
    fill_in 'Team b score', with: @game.team_b_score
    fill_in 'tournament', with: @game.tournament_id
    click_on 'Create Game'

    assert_text 'Game was successfully created'
    click_on 'Back'
  end

  test 'updating a Game' do
    visit games_url
    click_on 'Edit', match: :first

    fill_in 'Level', with: @game.level
    fill_in 'Team a', with: @game.team_a
    fill_in 'Team a score', with: @game.team_a_score
    fill_in 'Team b', with: @game.team_b
    fill_in 'Team b score', with: @game.team_b_score
    fill_in 'tournament', with: @game.tournament_id
    click_on 'Update Game'

    assert_text 'Game was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Game' do
    visit games_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Game was successfully destroyed'
  end
end
