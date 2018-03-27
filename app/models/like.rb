class Like < ApplicationRecord
  include SwaggerDocs::Like

  belongs_to :likeable, polymorphic: true
  belongs_to :liker, polymorphic: true

  validates_presence_of :liker, :likeable
  # validates :likeable, uniqueness: { scope: :liker }

  # scope :kept, -> { undiscarded.joins(:agency).merge(Agency.kept) }
  # scope :kept, -> { undiscarded.joins(:review).merge(Review.kept) }

  def presence?
    !discarded? && liker.presence? && likeable.presence?
  end
end
