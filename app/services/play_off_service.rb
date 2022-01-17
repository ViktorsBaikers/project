# frozen_string_literal: true

class PlayOffService
  attr_reader :game_tournament_id

  def initialize(game_tournament_id)
    @game_tournament_id = game_tournament_id
  end

  def play_play_off_game
    groups = Group.where(game_tournament_id: @game_tournament_id)

    winners = []
    loosers = []

    new_games_to_insert = []

    groups.each do |group|
      team_ids = group.team_ids.split(",").map(&:to_i)
      matches = Game.where(
        progress: "group-stage",
        game_tournament_id: @game_tournament_id
)
      match_results = GroupRanking.new(team_ids, matches).rank_match_results
      winners << match_results[0] # first in group
      loosers << match_results[1] # second in group
    end
    # first play off
    play_off_1 = match_score
    new_games_to_insert << {
      team_a_id: winners[0]["team_id"],
      team_b_id: loosers[1]["team_id"],
      team_a_score: play_off_1[0],
      team_b_score: play_off_1[1],
      game_tournament_id: @game_tournament_id,
      level: "Play Off Stage",
      progress: "play-off-stage",
      created_at: DateTime.now,
      updated_at: DateTime.now
    }

    # second play off
    play_off_2 = match_score
    new_games_to_insert << {
      team_a_id: winners[1]["team_id"],
      team_b_id: loosers[0]["team_id"],
      team_a_score: play_off_2[0],
      team_b_score: play_off_2[1],
      game_tournament_id: @game_tournament_id,
      level: "Play Off Stage",
      progress: "play-off-stage",
      created_at: DateTime.now,
      updated_at: DateTime.now
    }

    result = Game.insert_all(new_games_to_insert)
    puts result.inspect
  end

  private

    def match_score
      first_team_score = Random.rand(1..5)
      second_team_score = Random.rand(1..5)
      # here there must be a winner
      second_team_score = Random.rand(1..5) while first_team_score == second_team_score
      [first_team_score, second_team_score]
    end
end
