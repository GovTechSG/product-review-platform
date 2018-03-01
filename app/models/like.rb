class Like < ApplicationRecord
  include SwaggerDocs::Like
  belongs_to :user
  belongs_to :review

  validates_presence_of :user, :review
  validates :review_id, uniqueness: { scope: :user_id }

  def presence?
    !discarded? && user.presence? && review.presence?
  end
end
