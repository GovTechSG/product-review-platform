class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :score, :content
  belongs_to :reviewable, key: "object", serializer: ProductSerializer, if: :product?
  belongs_to :reviewable, key: "object", serializer: ServiceSerializer, if: :service?
  belongs_to :reviewer, serializer: AssociateCompanySerializer
  belongs_to :grant, serializer: GrantSerializer
  has_many :strengths, serializer: StrengthSerializer

  def product?
    instance_options[:reviewable].class == Product
  end

  def service?
    instance_options[:reviewable].class == Service
  end
end
