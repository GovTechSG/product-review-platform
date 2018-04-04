class Like < ApplicationRecord
  include SwaggerDocs::Like

  belongs_to :likeable, polymorphic: true
  belongs_to :liker, polymorphic: true

  validates_presence_of :liker, :likeable
  validate :unique_liker

  # scope :kept, -> { undiscarded.joins(:agency).merge(Agency.kept) }
  # scope :kept, -> { undiscarded.joins(:review).merge(Review.kept) }

  scope :match_liker_and_likeable, lambda { |liker_id, liker_type, likeable_id, likeable_type|
    where("liker_id = :liker_id AND liker_type = :liker_type
      AND likeable_id = :likeable_id AND likeable_type = :likeable_type",
          liker_id: liker_id, liker_type: liker_type,
          likeable_id: likeable_id, likeable_type: likeable_type)
  }

  def presence?
    !discarded? && liker.presence? && likeable.presence?
  end

  def unique_liker
    likers = Like.match_liker_and_likeable(liker_id, liker_type, likeable_id, likeable_type)
    errors.add(I18n.t('like.liker').to_s, I18n.t('like.like_restriction').to_s) unless
        likers.kept.blank? || likers.include?(self)
  end
end