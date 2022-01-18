# frozen_string_literal: true

class PlayOffService
  attr_reader :game_tournament_id, :groups, :new_games_to_insert, :winners, :losers

  def initialize(game_tournament_id)
    @game_tournament_id = game_tournament_id
    @groups = Group.where(game_tournament_id: game_tournament_id)
    @new_games_to_insert = []
    @winners = []
    @losers = []
  end

  def generate_play_off_game
    play_play_off_game
  end

  private

  def play_play_off_game
    generate_match_result(winners, losers)
    first_play_off_game(new_games_to_insert, winners, losers)
    second_play_off_game(new_games_to_insert, winners, losers)

    Game.insert_all(new_games_to_insert)
  end

  def generate_match_result(winners, losers)
    groups.each do |group|
      team_ids = JSON.parse(group.team_ids)
      games = Game.where(
        progress: Game::GROUP_STAGE,
        game_tournament_id: game_tournament_id
      )
      match_results = GroupRanking.new(team_ids, games).generate_results
      winners << match_results[0] # first in group
      losers << match_results[1] # second in group
    end
  end

  def first_play_off_game(new_games_to_insert, winners, losers)
    play_off_1 = match_score
    new_games_to_insert << {
      team_a_id: winners[0][:team_id],
      team_b_id: losers[1][:team_id],
      team_a_score: play_off_1[0],
      team_b_score: play_off_1[1],
      game_tournament_id: game_tournament_id,
      level: "Play Off Stage",
      progress: Game::PLAY_OFF_STAGE,
      created_at: DateTime.now,
      updated_at: DateTime.now
    }
  end

  def second_play_off_game(new_games_to_insert, winners, losers)
    play_off_2 = match_score
    new_games_to_insert << {
      team_a_id: winners[1][:team_id],
      team_b_id: losers[0][:team_id],
      team_a_score: play_off_2[0],
      team_b_score: play_off_2[1],
      game_tournament_id: game_tournament_id,
      level: "Play Off Stage",
      progress: Game::PLAY_OFF_STAGE,
      created_at: DateTime.now,
      updated_at: DateTime.now
    }
  end

  def match_score
    first_team_score = Random.rand(1..5)
    second_team_score = Random.rand(1..5)
    # Can't be draw
    second_team_score = Random.rand(1..5) while first_team_score == second_team_score
    [first_team_score, second_team_score]
  end
end
