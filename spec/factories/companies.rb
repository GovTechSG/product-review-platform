FactoryBot.define do
  factory :company do
    name { FFaker::Name.name }
    UEN { FFaker::Guid.guid }
    aggregate_score { rand(0.0..5.0) }
    description { FFaker::Lorem.sentence }
  end
end