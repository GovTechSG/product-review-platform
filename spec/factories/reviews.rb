FactoryBot.define do
  factory :review do
    score { FFaker.numerify("#") }
    content { FFaker::Lorem.paragraph }
    strengths { FFaker::Lorem.sentences }
    company
  end
end