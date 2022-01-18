require 'rails_helper'

RSpec.describe GroupGameService, type: :service do
  let(:service) { described_class.new(game_tournament.id) }
  let(:other_teams_1) { FactoryBot.create_list(:team, 8) }
  let(:other_teams_2) { FactoryBot.create_list(:team, 8) }

  let(:game_tournament) { create :game_tournament }
  let(:group_1) { create :group, game_tournament: game_tournament, team_ids: other_teams_1.pluck(:id) }
  let(:group_2) { create :group, game_tournament: game_tournament, team_ids: other_teams_2.pluck(:id) }

  context "#generate_scores" do
    it "returns created game scores for each team" do
      # We should save groups before executing the service
      group_1.save
      group_2.save

      service.generate_scores


      # Each team plays 7 matches. 16 x 7 = 112
      expect(game_tournament.games.count).to eq(112)
    end

  end
end
