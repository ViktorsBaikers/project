# frozen_string_literal: true

class Team < ApplicationRecord
  validates :name, :image, :abbrev, presence: true
end
