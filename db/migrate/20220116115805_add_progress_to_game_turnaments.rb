# frozen_string_literal: true

class AddProgressToGameTournaments < ActiveRecord::Migration[6.0]
  def change
    add_column :game_tournaments, :progress, :string, default: false
    add_column :games, :progress, :string, default: false
  end
end
