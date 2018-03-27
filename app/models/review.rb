class Review < ApplicationRecord
  include SwaggerDocs::Review
  include Statistics::Reviews

  include Commentable
  include Likeable

  belongs_to :reviewer, polymorphic: true
  belongs_to :company, -> { where(reviews: { reviewer_type: 'Company' }) },
             inverse_of: :reviews, foreign_key: 'reviewer_id', optional: true

  def company
    return unless reviewable_type == "Company"
    super
  end

  belongs_to :grant
  belongs_to :reviewable, polymorphic: true
  belongs_to :product, -> { where(reviews: { reviewable_type: 'Product' }) },
             inverse_of: :reviews, foreign_key: 'reviewable_id', optional: true
  belongs_to :service, -> { where(reviews: { reviewable_type: 'Service' }) },
             inverse_of: :reviews, foreign_key: 'reviewable_id', optional: true

  has_many :strength_reviews, dependent: :destroy
  has_many :strengths, through: :strength_reviews
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates_presence_of :score, :reviewer, :reviewable, :grant

  after_save :set_reviews_count, on: [:create, :update]

  scope :kept, -> { undiscarded.joins(:grant).merge(Grant.kept) }
  scope :kept, -> { undiscarded.joins(:company).merge(Company.kept) }
  scope :match_reviewable, lambda { |reviewable_id, reviewable_type|
    where("(reviewable_type = :reviewable_type AND reviewable_id in (:reviewable_id))",
          reviewable_id: reviewable_id,
          reviewable_type: reviewable_type)
  }

  def presence?
    !discarded? && reviewable.presence? && grant.presence? && reviewer.presence?
  end

  private

  def set_reviews_count
    set_reviewable_reviews_count
    set_company_reviews_count
  end

  def set_reviewable_reviews_count
    reviewable.reviews_count = reviewable.reviews.kept.count
    reviewable.save
  end

  def set_company_reviews_count
    company = reviewable.company
    product_count = company.products.kept.reduce(0) { |accum, product| accum + product.reviews.kept.count }
    service_count = company.services.kept.reduce(0) { |accum, service| accum + service.reviews.kept.count }
    company.reviews_count = product_count + service_count
    company.save
  end
end
