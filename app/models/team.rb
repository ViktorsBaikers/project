# frozen_string_literal: true

class Team < ApplicationRecord
  validates :name, presence: true
  validates :image, presence: true
  validates :abbrev, presence: true
end
