require 'rails_helper'

RSpec.describe PlayFinalService, type: :service do
  let(:service) { described_class.new(game_tournament.id) }
  let(:team_1) { create :team, name: "Latvia" }
  let(:team_2) { create :team, name: "Denmark" }
  let(:team_3) { create :team, name: "Norway" }
  let(:team_4) { create :team, name: "Sweden" }

  let(:game_tournament) { create :game_tournament, progress: Game::PLAY_OFF_STAGE }

  let(:game_1) do
    create :game,
      game_tournament: game_tournament,
      progress: Game::PLAY_OFF_STAGE,
      team_a_score: 1,
      team_b_score: 2,
      team_a_id: team_1.id,
      team_b_id: team_2.id
  end

  let(:game_2) do
    create :game,
      game_tournament: game_tournament,
      progress: Game::PLAY_OFF_STAGE,
      team_a_score: 2,
      team_b_score: 1,
      team_a_id: team_3.id,
      team_b_id: team_4.id
  end

  context "#generate_finals" do
    it "returns result of final game" do
      game_1.save
      game_2.save

      service.generate_finals

      final_game = game_tournament.games.last
      expect(game_tournament.games.count).to eq(3)
      expect(final_game.team_a_id).to eq(team_2.id)
      expect(final_game.team_b_id).to eq(team_3.id)
    end
  end
end
