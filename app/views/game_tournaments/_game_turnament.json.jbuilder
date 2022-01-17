json.extract! game_tournament, :id, :name, :status, :winner_id, :finalist_id, :created_at, :updated_at
json.url game_tournament_url(game_tournament, format: :json)
