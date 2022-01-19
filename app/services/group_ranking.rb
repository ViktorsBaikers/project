# frozen_string_literal: true

class GroupRanking
  attr_reader :team_ids, :games

  def initialize(team_ids, games = [])
    @team_ids = team_ids
    @games = games
  end

  def generate_results
    rank_match_results
  end

  private

  def rank_match_results
    ranking_hash = []
    team_ids.each do |team_id|
      results = calculate_rank(team_id)
      ranking_hash << { team_id: team_id, points: results[0], goals: results[1] }
    end
    ranking_hash.sort_by! { |team| (team[:points] + team[:goals]) }.
      reverse!
    ranking_hash
  end

  def calculate_rank(team_id)
    filtered_games = games.select {|game| game.team_a_id == team_id || game.team_b_id == team_id}
    points = 0
    goals = 0

    filtered_games.each do |match|
      if match.team_a_id == team_id
        goals += match.team_a_score
      elsif match.team_b_id == team_id
        goals += match.team_b_score
      end

      if match.team_a_id == team_id && match.team_a_score > match.team_b_score
        points += 3
      elsif match.team_a_id == team_id && match.team_a_score == match.team_b_score
        points += 1
      elsif match.team_b_id == team_id && match.team_b_score == match.team_a_score
        points += 1
      elsif match.team_b_id == team_id && match.team_b_score > match.team_a_score
        points += 3
      end
    end

    [points, goals]
  end
end
