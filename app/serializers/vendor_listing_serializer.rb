class VendorListingSerializer < ApplicationSerializer
  attributes :id, :name, :aggregate_score, :reviews_count, :image
  has_many :industries, serializer: IndustrySerializer
  has_many :projects, serializer: IndustrySerializer

  def image
    object.image.serializable_hash
  end
end
