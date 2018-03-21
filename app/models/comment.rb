class Comment < ApplicationRecord
  include SwaggerDocs::Comment
  belongs_to :agency
  belongs_to :review

  validates_presence_of :content, :agency, :review

  scope :kept, -> { undiscarded.joins(:agency).merge(Agency.kept) }
  scope :kept, -> { undiscarded.joins(:review).merge(Review.kept) }

  def presence?
    !discarded? && agency.presence? && review.presence?
  end
end
