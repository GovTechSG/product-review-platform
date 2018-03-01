class Comment < ApplicationRecord
  include SwaggerDocs::Comment
  belongs_to :user
  belongs_to :review

  validates_presence_of :content, :user, :review

  def presence?
    !discarded? && user.presence? && review.presence?
  end
end
