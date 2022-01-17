# frozen_string_literal: true

require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game = games(:one)
  end

  test "should get index" do
    get games_url
    assert_response :success
  end

  test "should get new" do
    get new_game_url
    assert_response :success
  end

  test "should create game" do
    assert_difference("Game.count") do
      post games_url,
        params: {
          game: {
            level: @game.level, team_a: @game.team_a, team_a_score: @game.team_a_score, team_b: @game.team_b,
            team_b_score: @game.team_b_score, tournament_id: @game.tournament_id
          }
        }
    end

    assert_redirected_to game_url(Game.last)
  end

  test "should show game" do
    get game_url(@game)
    assert_response :success
  end

  test "should get edit" do
    get edit_game_url(@game)
    assert_response :success
  end

  test "should update game" do
    patch game_url(@game),
      params: {
        game: {
          level: @game.level, team_a: @game.team_a, team_a_score: @game.team_a_score, team_b: @game.team_b,
          team_b_score: @game.team_b_score, tournament_id: @game.tournament_id
        }
      }
    assert_redirected_to game_url(@game)
  end

  test "should destroy game" do
    assert_difference("Game.count", -1) do
      delete game_url(@game)
    end

    assert_redirected_to games_url
  end
end
