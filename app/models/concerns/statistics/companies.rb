require 'set'

module Statistics::Companies
  extend ActiveSupport::Concern

  included do
    # These refer to the aggregate number of reviews of a vendor company's products and services
    # (different from #reviews method on company, see models/company.rb)
    def reviews_count
      self.products.reduce(0) { |accum, p| accum + p.reviews.count } + self.services.reduce(0) { |accum, s| accum + s.reviews.count }
    end

    def strengths
      strengths = Set.new()
      products.first(3).each do |p|
        p.reviews.first(3).each { |r| strengths.merge(r.strengths) }
      end
      services.first(3).each do |s|
        s.reviews.first(3).each { |r| strengths.merge(r.strengths) }
      end
      strengths.to_a
    end
  end
end
