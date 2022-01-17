class AddIndex < ActiveRecord::Migration[6.0]
    def change
      add_index :game_tournaments, :name, unique: true
    end
  end
  