class StatisticsController < ApiController
  include SwaggerDocs::Statistics

  before_action :authenticate_user!
  def index
    render :json => {
      reviews: Review.count,
      companies: Company.count,
      products: Product.count,
      services: Service.count
    }
  end
end
