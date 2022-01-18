# frozen_string_literal: true

class GroupGameService
  attr_reader :game_tournament_id, :groups, :new_games_to_insert

  def initialize(game_tournament_id)
    @game_tournament_id = game_tournament_id
    @groups = Group.where(game_tournament_id: game_tournament_id)
    @new_games_to_insert = []
  end

  def generate_scores
    play_group_game
  end

  private

  def play_group_game
    groups.each do |group|
      team_ids = JSON.parse(group.team_ids)
      teams = Team.where(id: team_ids)

      teams.each do |team, index|
        remaining_teams = (0..7).reject { |k| k == index } # 8 teams in groups indexes
        remaining_teams.each do |i|
          next if teams[i].id == team.id

          game_data_hash(team, teams[i])
        end
      end
    end
    Game.insert_all(new_games_to_insert)
  end

  def game_data_hash(team_a, team_b)
    result = match_score
    new_games_to_insert << {
      team_a_id: team_a.id,
      team_b_id: team_b.id,
      team_a_score: result[0],
      team_b_score: result[1],
      game_tournament_id: game_tournament_id,
      level: "Group Stage",
      progress: Game::GROUP_STAGE,
      created_at: DateTime.now,
      updated_at: DateTime.now
    }
  end

  def match_score
    first_team_score = Random.rand(1..5)
    second_team_score = Random.rand(1..5)
    # draw is allowed
    [first_team_score, second_team_score]
  end
end
