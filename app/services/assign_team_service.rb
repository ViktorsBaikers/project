# frozen_string_literal: true

class AssignTeamService
  attr_reader :game_tournament_id, :team_ids, :teams

  def initialize(team_ids, game_tournament_id)
    @team_ids = team_ids.reject(&:empty?).map(&:to_i)
    @game_tournament_id = game_tournament_id
    @teams = []
  end

  def assign
    process_team_ids

    assign_teams(teams.slice(0, 8), game_tournament_id, Group::GROUP_A)
    assign_teams(teams.slice(8, 16), game_tournament_id, Group::GROUP_B)
  end

  def process_team_ids
    if team_ids.length.zero?
      @teams = Team.pluck(:id).sample(16) # We might face an issue here if we would have a lot of teams
    elsif team_ids.length < 16
      @teams = team_ids + Team.where.not(id: team_ids).pluck(:id).sample(16 - team_ids.length)
    elsif team_ids.length >= 16
      @teams = team_ids.sample(16)
    end
  end

  private

  def assign_teams(team_ids, game_tournament_id, group_name)
    Group.create!(
      name: group_name,
      game_tournament_id: game_tournament_id,
      team_ids: team_ids
    )
  end
end
