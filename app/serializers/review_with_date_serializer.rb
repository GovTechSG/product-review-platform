class ReviewWithDateSerializer < ApplicationSerializer
  attributes :id, :score, :content, :created_at
  belongs_to :reviewable, key: "object", polymorphic: true
  belongs_to :reviewer, key: "from", polymorphic: true
  belongs_to :grant, serializer: GrantSerializer
  has_many :aspects, serializer: AspectSerializer

  def self.serializer_for(model, options)
    return AssociateCompanySerializer if model.class.name == I18n.t('company.key').to_s
    super
  end
end