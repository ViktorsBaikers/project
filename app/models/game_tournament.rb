class GameTournament < ApplicationRecord
    attr_accessor :team_ids
    has_many :groups, dependent: :destroy
    has_many :games, dependent: :destroy
    validates_uniqueness_of :name
    validates_presence_of :name
    validates_presence_of :status

end
