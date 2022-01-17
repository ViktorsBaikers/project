# frozen_string_literal: true

json.extract! game, :id, :team_a, :team_b, :team_a_score, :team_b_score, :tournament_id, :level, :created_at,
              :updated_at
json.url game_url(game, format: :json)
