# frozen_string_literal: true

class CreateGameTournaments < ActiveRecord::Migration[6.0]
  def change
    create_table(:game_tournaments) do |t|
      t.string(:name)
      t.string(:status)
      t.integer(:winner_id, index: true)
      t.integer(:finalist_id, index: true)

      t.timestamps
    end
  end
end
