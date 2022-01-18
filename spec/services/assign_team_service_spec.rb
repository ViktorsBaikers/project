require 'rails_helper'

RSpec.describe AssignTeamService, type: :service do
  let(:service) { described_class.new(%W[#{team_1.id} #{other_teams.pluck(:id)}], game_tournament.id) }
  let(:team_1) { create :team, name: "Latvia" }
  let(:other_teams) { FactoryBot.create_list(:team, 15) }

  let(:game_tournament) { create :game_tournament }

  context "#assign" do
    it "returns created groups with assigned commands" do
      service.assign

      expect(game_tournament.groups.count).to eq(2)
      expect(JSON.parse(game_tournament.groups[0].team_ids).count).to eq(8)
    end
  end
end
