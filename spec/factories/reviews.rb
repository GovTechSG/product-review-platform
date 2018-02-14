FactoryBot.define do
  factory :review do
    score { FFaker.numerify("#") }
    content { FFaker::Lorem.paragraphs }
    company
  end
end