module Statistics::Companies
  extend ActiveSupport::Concern

  included do
    def reviews_count
      self.products.reduce(0) { |accum, p| accum + p.reviews.count } + self.services.reduce(0) { |accum, s| accum + s.reviews.count }
    end
  end
end
