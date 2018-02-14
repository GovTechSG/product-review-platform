FactoryBot.define do
  factory :company do
    name { FFaker::Name.name }
    UEN { FFaker::Guid.guid }
    aggregate_score { FFaker.numerify("#.#") }
    description { FFaker::Lorem.sentence }
  end
end