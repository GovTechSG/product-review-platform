class Review < ApplicationRecord
  include SwaggerDocs::Review
  include Statistics::Reviews

  belongs_to :reviewer, polymorphic: true
  belongs_to :company, -> { where(reviews: { reviewer_type: 'Company' }) },
             inverse_of: :reviews, foreign_key: 'reviewer_id', optional: true

  # Check if its Company
  def company
    return unless reviewable_type == "Company"
    super
  end

  belongs_to :grant
  belongs_to :reviewable, polymorphic: true

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :strength_reviews, dependent: :destroy
  has_many :strengths, through: :strength_reviews

  validates_presence_of :score, :reviewer, :reviewable, :grant

  after_save :set_reviews_count, on: [:create, :update]

  scope :kept, -> { undiscarded.joins(:grant).merge(Grant.kept) }
  # scope :kept, -> { undiscarded.joins(:reviewer).merge(Reviewer.kept) }
  scope :kept, -> { undiscarded.joins(:company).merge(Company.kept) }

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
