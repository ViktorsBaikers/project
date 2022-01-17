class Game < ApplicationRecord
    has_one :team_a, class_name: 'Team', foreign_key: :team_a_id
    has_one :team_b, class_name: 'Team', foreign_key: :team_b_id
    belongs_to :game_tournament
    validates_presence_of :team_a_score
    validates_presence_of :team_b_score
    validates_presence_of :level
end
