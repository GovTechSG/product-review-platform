class Company < ApplicationRecord
  include SwaggerDocs::Company
  include Statistics::Companies

  # These refer to the reviews written by a claimant company
  # (different from reviews_count, see models/concerns/statistics/companies.rb)
  has_many :reviews, dependent: :destroy

  has_many :products, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :industry_companies, dependent: :destroy
  has_many :industries, through: :industry_companies

  validates_presence_of :name, :uen, :aggregate_score, :description, :reviews_count
  validates_uniqueness_of :uen, :name
end
