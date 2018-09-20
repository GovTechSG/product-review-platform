FactoryBot.define do
  factory :company do
    name { FFaker::Name.name }
    uen { FFaker::Guid.guid }
    aggregate_score 0
    reviews_count 0
    description { FFaker::Lorem.sentence }
    url { FFaker::Internet.http_url }
    phone_number { FFaker::PhoneNumberSG.fixed_line_number }
  end

  factory :company_as_params, class: Hash do
    name { FFaker::Name.name }
    uen { FFaker::Guid.guid }
    aggregate_score 0
    reviews_count 0
    description { FFaker::Lorem.sentence }
    url { FFaker::Internet.http_url }
    phone_number { FFaker::PhoneNumberSG.fixed_line_number }
    image "data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs="

    initialize_with { attributes }
  end
end