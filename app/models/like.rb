class Like < ApplicationRecord
  include SwaggerDocs::Like
  belongs_to :agency
  belongs_to :review

  validates_presence_of :agency, :review
  validates :review_id, uniqueness: { scope: :agency_id }

  scope :kept, -> { undiscarded.joins(:agency).merge(Agency.kept) }
  scope :kept, -> { undiscarded.joins(:review).merge(Review.kept) }

  def presence?
    !discarded? && agency.presence? && review.presence?
  end
end
