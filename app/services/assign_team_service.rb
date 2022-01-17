# frozen_string_literal: true

class AssignTeamService
  attr_reader :game_tournament_id, :team_ids

  def initialize(team_ids, game_tournament_id)
    @team_ids = team_ids.reject(&:empty?).map(&:to_i)
    @game_tournament_id = game_tournament_id
  end

  def process_team_ids
    teams = []
    if team_ids.length.zero?
      teams = Team.all.sample(16).map(&:id)
    elsif team_ids.length.positive? && team_ids.length < 16
      temp = Team.where.not(id: team_ids)
      offset = 16 - team_ids.length
      temp = temp.shuffle.slice(0, offset).map(&:id)
      teams = temp + team_ids
    elsif team_ids.length >= 16
      teams = team_ids.sample(16)
    end
    group_a = teams.slice(0, 8)
    group_b = teams.slice(8, 16)
    assign_teams(group_a, game_tournament_id, "A")
    assign_teams(group_b, game_tournament_id, "B")
  end

  private

    def assign_teams(team_ids, game_tournament_id, group_name)
      team_str_ids = ""
      len = team_ids.length
      team_ids.each do |id, idx|
        team_str_ids += id.to_s
        team_str_ids += "," if idx != len - 1
      end
      Group.create!(
        name: group_name, game_tournament_id: game_tournament_id,
        team_ids: team_str_ids
)
    end
end
