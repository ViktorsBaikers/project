# frozen_string_literal: true

class GroupGameService
  attr_reader :game_tournament_id

  def initialize(game_tournament_id)
    @game_tournament_id = game_tournament_id
  end

  def play_group_game
    groups = Group.where(game_tournament_id: @game_tournament_id)
    new_games_to_insert = []
    groups.each do |group|
      team_ids = group.team_ids.split(',').map(&:to_i)
      teams = Team.where('id IN (?)', team_ids)
      # 8 teams in groups indexes
      indexes = [0, 1, 2, 3, 4, 5, 6, 7]

      teams.each do |elem, index|
        remaining_teams = indexes.reject { |k| k == index }
        remaining_teams.each do |i|
          next if teams[i].id == elem.id

          result = matchScore
          new_games_to_insert << {
            team_a_id: elem.id,
            team_b_id: teams[i].id,
            team_a_score: result[0],
            team_b_score: result[1],
            game_tournament_id: @game_tournament_id,
            level: 'Group Stage',
            progress: 'group-stage',
            created_at: DateTime.now,
            updated_at: DateTime.now
          }
        end
      end
    end

    result = Game.insert_all(new_games_to_insert)
    puts result.inspect
  end

  private

  def matchScore
    rndInt1 = Random.rand(1..5)
    rndInt12 = Random.rand(1..5)
    # draw is allowed
    [rndInt1, rndInt12]
  end
end
