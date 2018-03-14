class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :score, :content, :strengths
  belongs_to :reviewable, key: "object", serializer: ProductSerializer, if: :product?
  belongs_to :reviewable, key: "object", serializer: ServiceSerializer, if: :service?
  belongs_to :reviewer, key: "from", serializer: CompanySerializer, if: :company?
  belongs_to :grant, serializer: GrantSerializer

  def product?
    instance_options[:reviewable].class == Product
  end

  def service?
    instance_options[:reviewable].class == Service
  end

  def company?
    instance_options[:reviewable].company.class == Company
  end
end
