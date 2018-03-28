class LikeSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :likeable, key: "object", polymorphic: true
  belongs_to :liker, key: "from", polymorphic: true

  def self.serializer_for(model, options)
    return AssociateCompanySerializer if model.class.name == 'Company'
    super
  end
end
