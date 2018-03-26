class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :score, :content
  belongs_to :reviewable, key: "object", polymorphic: true
  belongs_to :reviewer, key: "from", polymorphic: true

  belongs_to :grant, serializer: GrantSerializer
  has_many :strengths, serializer: StrengthSerializer

  def self.serializer_for(model, options)
    return AssociateCompanySerializer if model.class.name == 'Company'
    super
  end
end
