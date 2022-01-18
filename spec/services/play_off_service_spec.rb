require 'rails_helper'

RSpec.describe PlayOffService, type: :service do
  let(:service) { described_class.new(game_tournament.id) }
  let(:team_1) { create :team, name: "Latvia" }
  let(:team_2) { create :team, name: "Denmark" }
  let(:team_3) { create :team, name: "Norway" }
  let(:team_4) { create :team, name: "Sweden" }

  let(:game_tournament) { create :game_tournament }
  let(:group_1) { create :group, game_tournament: game_tournament, team_ids: [team_1.id, team_2.id] }
  let(:group_2) { create :group, game_tournament: game_tournament, team_ids: [team_3.id, team_4.id] }

  context "#generate_scores" do
    it "returns play-off games" do
      # We should save groups before executing the service
      group_1.save
      group_2.save

      service.generate_play_off_game

      expect(game_tournament.games.count).to eq(2)

      expect(game_tournament.games[0].team_a_id).to eq(team_2.id)
      expect(game_tournament.games[0].team_b_id).to eq(team_3.id)

      expect(game_tournament.games[1].team_a_id).to eq(team_4.id)
      expect(game_tournament.games[1].team_b_id).to eq(team_1.id)
    end
  end
end
