class StrengthReview < ApplicationRecord
  belongs_to :strength
  belongs_to :review

  scope :kept, -> { undiscarded.joins(:strength).merge(Strength.kept) }
  scope :kept, -> { undiscarded.joins(:review).merge(Review.kept) }
end
