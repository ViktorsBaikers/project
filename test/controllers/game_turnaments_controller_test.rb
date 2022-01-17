require 'test_helper'

class GametournamentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game_tournament = game_tournaments(:one)
  end

  test "should get index" do
    get game_tournaments_url
    assert_response :success
  end

  test "should get new" do
    get new_game_tournament_url
    assert_response :success
  end

  test "should create game_tournament" do
    assert_difference('Gametournament.count') do
      post game_tournaments_url, params: { game_tournament: { finalist_id: @game_tournament.finalist_id, name: @game_tournament.name, status: @game_tournament.status, winner_id: @game_tournament.winner_id } }
    end

    assert_redirected_to game_tournament_url(Gametournament.last)
  end

  test "should show game_tournament" do
    get game_tournament_url(@game_tournament)
    assert_response :success
  end

  test "should get edit" do
    get edit_game_tournament_url(@game_tournament)
    assert_response :success
  end

  test "should update game_tournament" do
    patch game_tournament_url(@game_tournament), params: { game_tournament: { finalist_id: @game_tournament.finalist_id, name: @game_tournament.name, status: @game_tournament.status, winner_id: @game_tournament.winner_id } }
    assert_redirected_to game_tournament_url(@game_tournament)
  end

  test "should destroy game_tournament" do
    assert_difference('Gametournament.count', -1) do
      delete game_tournament_url(@game_tournament)
    end

    assert_redirected_to game_tournaments_url
  end
end
