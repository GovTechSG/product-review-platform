# Creating test data
# Current implementation only test that ApplicationController works with
# ApplicationController. Other tests will be added with later user stories
FactoryBot.define do
  factory :agency do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    number { FFaker::PhoneNumberSG.fixed_line_number }
  end

  factory :app do
    name { FFaker::Name.name }
    password { FFaker::Internet.password }
  end

  factory :comment do
    content { FFaker::Lorem.paragraphs }
    agency
  end

  factory :product_review_comment, parent: :comment do
    association :review, factory: :product_review
  end

  factory :service_review_comment, parent: :comment do
    association :review, factory: :service_review
  end

  factory :company do
    name { FFaker::Name.name }
    UEN { FFaker::Guid.guid }
    aggregate_score { FFaker.numerify("#.#") }
    description { FFaker::Lorem.sentence }
  end

  factory :like do
    agency
  end

  factory :product_review_like, parent: :like do
    association :review, factory: :product_review
  end

  factory :service_review_like, parent: :like do
    association :review, factory: :service_review
  end

  factory :product do
    name { FFaker::Name.name }
    description { FFaker::Lorem.sentence }
    company
  end

  factory :service do
    name { FFaker::Name.name }
    description { FFaker::Lorem.sentence }
    company
  end

  factory :review do
    score { FFaker.numerify("#") }
    content { FFaker::Lorem.paragraphs }
    company
  end

  factory :product_review, parent: :review do
    association :reviewable, factory: :product
  end

  factory :service_review, parent: :review do
    association :reviewable, factory: :service
  end
end
