class Company < Reviewer
  include SwaggerDocs::Company
  include Statistics::Companies

  # These refer to the reviews written by a claimant company
  # (different from reviews_count, see models/concerns/statistics/companies.rb)
  has_many :reviews, dependent: :destroy

  has_many :products, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :industry_companies, dependent: :destroy
  has_many :industries, through: :industry_companies

  validates_presence_of :name, :UEN, :aggregate_score, :description
  validates_uniqueness_of :UEN, :name
end
