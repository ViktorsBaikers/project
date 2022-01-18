# frozen_string_literal: true

class PlayFinalService
  attr_reader :game_tournament_id

  def initialize(game_tournament_id)
    @game_tournament_id = game_tournament_id
  end

  def play_final_game
    groups = Group.where(game_tournament_id: @game_tournament_id)
    matches = Game.where(
      progress: Game::PLAY_OFF_STAGE,
      game_tournament_id: @game_tournament_id
)
    winners = []
    matches.each do |match|
      winners << if match.team_a_score > match.team_b_score
                   match.team_a_id
                 else
                   match.team_b_id
                 end
    end
    # first play off
    play_final = match_score
    game = Game.create!(
      team_a_id: winners[0],
      team_b_id: winners[1],
      team_a_score: play_final[0],
      team_b_score: play_final[1],
      game_tournament_id: @game_tournament_id,
      level: "Play Off Stage",
      progress: Game::FINAL_STAGE
    )
    # finalize tournament
    finalise_tournament(game)
  end

  private

    def finalise_tournament(game)
      final_winner = 0
      finalist = 0
      finalist =
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
