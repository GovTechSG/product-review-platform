class Strength < ApplicationRecord
  include SwaggerDocs::Strength

  has_many :strength_reviews, dependent: :destroy
  has_many :reviews, through: :strength_reviews

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
end
