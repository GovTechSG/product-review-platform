class Comment < ApplicationRecord
  include SwaggerDocs::Comment

  belongs_to :commentable, polymorphic: true
  belongs_to :commenter, polymorphic: true

  validates_presence_of :content, :commenter, :commentable

  # scope :kept, -> { undiscarded.joins(:agency).merge(Agency.kept) }
  # scope :kept, -> { undiscarded.joins(:review).merge(Review.kept) }

  def presence?
    !discarded? && commenter.presence? && commentable.presence?
  end
end
