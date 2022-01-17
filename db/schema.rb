# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_220_116_115_806) do
  create_table 'game_tournaments', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci',
                                   force: :cascade do |t|
    t.string 'name'
    t.string 'status'
    t.integer 'winner_id'
    t.integer 'finalist_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'progress', default: '0'
    t.index ['finalist_id'], name: 'index_game_tournaments_on_finalist_id'
    t.index ['name'], name: 'index_game_tournaments_on_name', unique: true
    t.index ['winner_id'], name: 'index_game_tournaments_on_winner_id'
  end

  create_table 'games', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci',
                        force: :cascade do |t|
    t.integer 'team_a_id'
    t.integer 'team_b_id'
    t.integer 'team_a_score'
    t.integer 'team_b_score'
    t.bigint 'game_tournament_id'
    t.string 'level'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'progress', default: '0'
    t.index ['game_tournament_id'], name: 'index_games_on_game_tournament_id'
    t.index ['team_a_id'], name: 'index_games_on_team_a_id'
    t.index ['team_b_id'], name: 'index_games_on_team_b_id'
  end

  create_table 'groups', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci',
                         force: :cascade do |t|
    t.string 'name'
    t.bigint 'game_tournament_id'
    t.text 'team_ids'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['game_tournament_id'], name: 'index_groups_on_game_tournament_id'
  end

  create_table 'teams', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci',
                        force: :cascade do |t|
    t.string 'name'
    t.string 'abbrev'
    t.string 'image'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  add_foreign_key 'games', 'game_tournaments'
  add_foreign_key 'groups', 'game_tournaments'
end
