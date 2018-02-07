class StatisticsController < ApplicationController
  include SwaggerDocs::Statistics
  before_action :doorkeeper_authorize!
  def index
    render :json => {
      reviews: Review.count,
      companies: Company.count,
      products: Product.count,
      services: Service.count
    }
  end
end
