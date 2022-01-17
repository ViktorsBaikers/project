class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.integer :team_a_id, index: true
      t.integer :team_b_id, index: true
      t.integer :team_a_score
      t.integer :team_b_score
      t.references :game_tournament, foreign_key: true
      t.string :level

      t.timestamps
    end
 
  end
end
