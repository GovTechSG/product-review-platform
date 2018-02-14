class Company < ApplicationRecord
  include SwaggerDocs::Company
  include Statistics::Companies
  include Discard::Model

  # These refer to the reviews written by a claimant company
  # (different from reviews_count, see models/concerns/statistics/companies.rb)
  has_many :reviews, dependent: :destroy

  has_many :products, dependent: :destroy
  has_many :services, dependent: :destroy

  validates_presence_of :name, :UEN, :aggregate_score, :description
  validates :aggregate_score, inclusion: { in: 0..5 }
end
