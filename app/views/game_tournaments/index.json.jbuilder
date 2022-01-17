# frozen_string_literal: true

json.array! @game_tournaments, partial: 'game_tournaments/game_tournament', as: :game_tournament
