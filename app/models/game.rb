# frozen_string_literal: true

class Game < ApplicationRecord
  has_one :team_a, class_name: "Team", foreign_key: :team_a_id
  has_one :team_b, class_name: "Team", foreign_key: :team_b_id
  belongs_to :game_tournament
  validates :team_a_score, presence: true
  validates :team_b_score, presence: true
  validates :level, presence: true
end
