module Statistics::Companies
  extend ActiveSupport::Concern

  included do
    def reviews_count
      num_product_reviews = 0
      self.products.each do |pdt|
        num_product_reviews += pdt.reviews.count
      end
      num_service_reviews = 0
      self.services.each do |svc|
        num_service_reviews += svc.reviews.count
      end
      num_product_reviews + num_service_reviews
    end
  end
end
