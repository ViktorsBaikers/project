# frozen_string_literal: true

class GameTournament < ApplicationRecord
  attr_accessor :team_ids

  STATUS_DRAFT = "draft"
  STATUS_IN_PROGRESS = "in_progress"
  STATUS_DONE = "done"

  has_many :groups, dependent: :destroy
  has_many :games, dependent: :destroy
  validates :name, uniqueness: true
  validates :name, :status, presence: true
end
