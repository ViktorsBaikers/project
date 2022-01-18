# frozen_string_literal: true

class Game < ApplicationRecord
  GROUP_STAGE = "group-stage"
  FINAL_STAGE = "final-stage"
  PLAY_OFF_STAGE = "play-off-stage"

  COMPLETED = "completed"

  has_one :team_a, class_name: "Team", foreign_key: :team_a_id
  has_one :team_b, class_name: "Team", foreign_key: :team_b_id

  belongs_to :game_tournament

  validates :team_a_score, :team_b_score, :level, presence: true
end
