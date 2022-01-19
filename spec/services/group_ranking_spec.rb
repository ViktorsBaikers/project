require 'rails_helper'

RSpec.describe GroupRanking, type: :service do
  let(:service) { described_class.new([team_1.id, team_2.id, team_3.id, team_4.id], [game_1, game_2]) }
  let(:team_1) { create :team, name: "Latvia" }
  let(:team_2) { create :team, name: "Denmark" }
  let(:team_3) { create :team, name: "Norway" }
  let(:team_4) { create :team, name: "Sweden" }

  let(:game_tournament) { create :game_tournament, progress: Game::GROUP_STAGE }

  let(:game_1) do
    create :game,
      game_tournament: game_tournament,
      progress: Game::GROUP_STAGE,
      team_a_score: 3,
      team_b_score: 1,
      team_a_id: team_1.id,
      team_b_id: team_2.id
  end

  let(:game_2) do
    create :game,
      game_tournament: game_tournament,
      progress: Game::GROUP_STAGE,
      team_a_score: 2,
      team_b_score: 4,
      team_a_id: team_3.id,
      team_b_id: team_4.id
  end

  context "#generate_results" do
    it "returns point number of each team" do
      game_1.save
      game_2.save

      service.generate_results

      expect(service.generate_results).to eq(
        [
          { :team_id => team_4.id, :points => 3, :goals => 4 },
          { :team_id => team_1.id, :points => 3, :goals => 3 },
          { :team_id => team_3.id, :points => 0, :goals => 2 },
          { :team_id => team_2.id, :points => 0, :goals => 1 }
        ]
      )
    end
  end
end
