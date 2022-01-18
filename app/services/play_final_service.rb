# frozen_string_literal: true

class PlayFinalService
  attr_reader :game_tournament_id, :winners, :games

  def initialize(game_tournament_id)
    @game_tournament_id = game_tournament_id
    @games = Game.where(game_tournament_id: game_tournament_id, progress: Game::PLAY_OFF_STAGE)
    @winners = []
  end

  def generate_finals
    play_final_game
  end

  private

  def play_final_game
    games.each do |game|
      if game.team_a_score > game.team_b_score
        winners << game.team_a_id
      else
        winners << game.team_b_id
      end
    end
    finalise_tournament(generate_game)
  end

  def generate_game
    play_final = match_score
    Game.create!(
      team_a_id: winners[0],
      team_b_id: winners[1],
      team_a_score: play_final[0],
      team_b_score: play_final[1],
      game_tournament_id: game_tournament_id,
      level: "Play Off Stage",
      progress: Game::FINAL_STAGE
    )
  end

  def finalise_tournament(game)
    finalist = \
      if game.team_a_score > game.team_b_score
        final_winner = game.team_a_id
        game.team_b_id
      else
        final_winner = game.team_b_id
        game.team_a_id
      end
    [final_winner, finalist]
  end

  def match_score
    first_team_score = Random.rand(1..5)
    second_team_score = Random.rand(1..5)
    # here there must be a winner
    second_team_score = Random.rand(1..5) while first_team_score == second_team_score
    [first_team_score, second_team_score]
  end
end
