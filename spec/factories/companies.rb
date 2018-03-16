FactoryBot.define do
  factory :company do
    name { FFaker::Name.name }
    uen { FFaker::Guid.guid }
    aggregate_score { rand(1.0..10.0) }
    description { FFaker::Lorem.sentence }
  end
end