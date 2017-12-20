class StatisticsController < ApplicationController
  def index
    render :json => {
      reviews: Review.count,
      companies: Company.count,
      products: Product.count,
      services: Service.count
    }
  end
end
