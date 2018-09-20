FactoryBot.define do
  factory :project do
    name { FFaker::Name.name }
    description { FFaker::Lorem.sentence }
    reviews_count 0
    aggregate_score 0
  end
end