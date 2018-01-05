class Company < ApplicationRecord
  include SwaggerDocs::Company
  include Statistics::Companies

  # These refer to the reviews written by a claimant company
  # (different from reviews_count, see models/concerns/statistics/companies.rb)
  has_many :reviews, dependent: :destroy

  has_many :products, dependent: :destroy
  has_many :services, dependent: :destroy

  validates_presence_of :name, :UEN, :aggregate_score, :description
end
