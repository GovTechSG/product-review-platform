class Like < ApplicationRecord
  include SwaggerDocs::Like
  belongs_to :agency
  belongs_to :review

  validates_presence_of :agency, :review
  validates :review_id, uniqueness: { scope: :agency_id }

  def presence?
    !discarded? && agency.presence? && review.presence?
  end
end
