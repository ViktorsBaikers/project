# frozen_string_literal: true

class Group < ApplicationRecord
  belongs_to :game_tournament
  validates_presence_of :name
end
