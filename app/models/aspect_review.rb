class AspectReview < ApplicationRecord
  belongs_to :aspect
  belongs_to :review

  scope :kept, -> { undiscarded.joins(:aspect).merge(Aspect.kept) }
  scope :kept, -> { undiscarded.joins(:review).merge(Review.kept) }
end
