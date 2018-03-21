class Company < Reviewer
  include SwaggerDocs::Company
  include Statistics::Companies

  # These refer to the reviews written by a claimant company
  # (different from reviews_count, see models/concerns/statistics/companies.rb)
  has_many :reviews, dependent: :destroy, as: :reviewer

  has_many :products, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :industry_companies, dependent: :destroy
  has_many :industries, through: :industry_companies

  validates_presence_of :name, :uen, :aggregate_score, :description, :reviews_count
  validates_uniqueness_of :uen, :name
  validates :url, allow_blank: true, url: true

  def grants
    product_reviews = products.kept.reduce([]) { |accum, product| accum + product.reviews.kept }
    service_reviews = services.kept.reduce([]) { |accum, service| accum + service.reviews.kept }
    all_reviews = (product_reviews + service_reviews).uniq
    grants = all_reviews.reduce([]) { |accum, review| review.grant.presence? ? accum.push(review.grant) : accum }
    if !grants.nil?
      grants.uniq
    else
      []
    end
  end

  def clients
    product_reviews = products.kept.reduce([]) { |accum, product| accum + product.reviews.kept }
    service_reviews = services.kept.reduce([]) { |accum, service| accum + service.reviews.kept }
    all_reviews = (product_reviews + service_reviews).uniq
    clients = all_reviews.reduce([]) { |accum, review| review.reviewer.presence? ? accum.push(review.reviewer) : accum }
    if !clients.nil?
      clients.uniq
    else
      []
    end
  end
end
