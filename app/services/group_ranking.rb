# frozen_string_literal: true

class GroupRanking
  attr_reader :team_ids, :games

  def initialize(team_ids, games = [])
    @team_ids = team_ids
    @games = games
  end

  def rank_match_results
    ranking_hash = []
    team_ids.each do |uid|
      results = calculate_rank(uid)
      ranking_hash << { 'team_id' => uid, 'points' => results[0], 'goals' => results[1] }
    end
    ranking_hash.sort_by! { |team| (team['points'] + team['goals']) }.reverse!
    ranking_hash
  end

  private

  def calculate_rank(uid)
    filtered_games = games.select { |r| r.team_a_id == uid || r.team_b_id == uid }
    points = 0
    goals = 0

    filtered_games.each do |m|
      if m.team_a_id == uid
        goals += m.team_a_score
      elsif m.team_b_id == uid
        goals += m.team_b_score
      end

      if m.team_a_id == uid && m.team_a_score > m.team_b_score
        points += 3
      elsif m.team_a_id == uid && m.team_a_score == m.team_b_score
        points += 1
      elsif m.team_b_id == uid && m.team_b_score == m.team_a_score
        points += 1
      elsif m.team_b_id == uid && m.team_b_score > m.team_a_score
        points += 3
      end
    end

    [points, goals]
  end
end
