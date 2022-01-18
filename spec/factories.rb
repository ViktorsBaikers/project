# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "Team_#{n}" }
    abbrev { "cn" }
    image { "img" }
  end

  factory :game_tournament do
    sequence(:name) { |n| "game_tournament_#{n}" }
  end

  factory :group do
    sequence(:name) { |n| "group_#{n}" }
    association :game_tournament
  end

  factory :game do
    sequence(:team_a_score)
    sequence(:team_b_score)
    level { "Group Stage" }
    progress { "group-stage" }
    association :game_tournament
  end
end
