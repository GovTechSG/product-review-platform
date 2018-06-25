FactoryBot.define do
  factory :service do
    name { FFaker::Name.name }
    description { FFaker::Lorem.sentence }
    reviews_count 0
    aggregate_score 0
    company
  end
end