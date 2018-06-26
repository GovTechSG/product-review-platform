class VendorListingSerializer < ApplicationSerializer
  attributes :id, :name, :aggregate_score, :reviews_count, :image
  has_many :industries, serializer: IndustrySerializer
  has_many :project_industries, serializer: IndustrySerializer

  def image
    object.image.serializable_hash
  end

  def project_industries
    object.reviewable_industries("Project")
  end
end
