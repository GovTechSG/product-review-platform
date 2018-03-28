class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content

  belongs_to :commentable, key: "object", polymorphic: true
  belongs_to :commenter, key: "from", polymorphic: true

  def self.serializer_for(model, options)
    return AssociateCompanySerializer if model.class.name == 'Company'
    super
  end
end
