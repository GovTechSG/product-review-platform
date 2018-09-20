require 'set'

module Statistics::Companies
  extend ActiveSupport::Concern

  included do
    def aspects
      product_aspect = Aspect.match_product(self.products.kept.pluck(:id)).first(6)
      service_aspect = Aspect.match_service(self.services.kept.pluck(:id)).first(6)
      whole_set = product_aspect + service_aspect
      whole_set.empty? ? [] : serialize(whole_set.uniq.first(6))
    end

    private

    def get_reviews_as_vendor(product_service)
      aspects_set = Set.new
      product_service.first(3).each do |reviewable|
        reviewable.reviews.kept.first(3).each do |review|
          aspects_set.merge(serialize(review.aspects))
        end
      end
      aspects_set
    end

    def serialize(aspects)
      aspects.map do |aspect|
        aspect = ActiveModel::SerializableResource.new(aspect)
        aspect.as_json
      end
    end
  end
end
