class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.references :game_tournament, foreign_key: true
      t.text :team_ids
      t.timestamps
    end
    
  end
end
