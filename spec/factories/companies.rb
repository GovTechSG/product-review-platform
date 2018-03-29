FactoryBot.define do
  factory :company do
    name { FFaker::Name.name }
    uen { FFaker::Guid.guid }
    aggregate_score { rand(1.0..10.0) }
    description { FFaker::Lorem.sentence }
    url { FFaker::Internet.http_url }
    phone_number { FFaker::PhoneNumberSG.fixed_line_number }
  end
end