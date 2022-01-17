# frozen_string_literal: true

json.extract! group, :id, :name, :tournament_id, :team_ids, :created_at, :updated_at
json.url group_url(group, format: :json)
