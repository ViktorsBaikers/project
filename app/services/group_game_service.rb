# frozen_string_literal: true

class GroupGameService
  attr_reader :game_tournament_id

  def initialize(game_tournament_id)
    @game_tournament_id = game_tournament_id
    @groups = Group.where(game_tournament_id: game_tournament_id)
  end

  def generate_scores
    play_group_game
  end

  private

  def play_group_game
    new_games_to_insert = []
    @groups.each do |group|
      team_ids = JSON.parse(group.team_ids)
      teams = Team.where(id: team_ids)

      teams.each do |team, index|
        remaining_teams = (0..7).reject { |k| k == index } # 8 teams in groups indexes
        remaining_teams.each do |i|
          next if teams[i].id == team.id

          result = match_score
          new_games_to_insert << {
            team_a_id: team.id,
            team_b_id: teams[i].id,
            team_a_score: result[0],
            team_b_score: result[1],
            game_tournament_id: game_tournament_id,
            level: "Group Stage",
            progress: Game::GROUP_STAGE
          }
        end
      end
    end
    Game.insert_all(new_games_to_insert)
  end

  def match_score
    first_team_score = Random.rand(1..5)
    second_team_score = Random.rand(1..5)
    # draw is allowed
    [first_team_score, second_team_score]
  end
end
