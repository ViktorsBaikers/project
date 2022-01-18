# frozen_string_literal: true

class Group < ApplicationRecord
  GROUP_A = "A"
  GROUP_B = "B"

  belongs_to :game_tournament
  validates :name, presence: true
end
