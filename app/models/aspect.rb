class Aspect < ApplicationRecord
  include SwaggerDocs::Aspect

  has_many :aspect_reviews, dependent: :destroy
  has_many :reviews, through: :aspect_reviews

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  scope :match_product, lambda { |product_id|
    joins(:reviews).distinct.where("reviews.reviewable_id in (?) AND reviews.reviewable_type = 'Product'", product_id)
  }

  scope :match_service, lambda { |service_id|
    joins(:reviews).distinct.where("reviews.reviewable_id in (?) AND reviews.reviewable_type = 'Service'", service_id)
  }
end
