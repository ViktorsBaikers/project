# frozen_string_literal: true

class GameTournament < ApplicationRecord
  attr_accessor :team_ids

  has_many :groups, dependent: :destroy
  has_many :games, dependent: :destroy
  validates :name, uniqueness: true
  validates :name, presence: true
  validates :status, presence: true
end
