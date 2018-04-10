class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content

  belongs_to :commentable, key: "object", polymorphic: true
  belongs_to :commenter, key: "from", polymorphic: true

  def self.serializer_for(model, options)
    return AssociateCompanySerializer if model.class.name == I18n.t('company.key').to_s
    super
  end

  def id
    object.hashid
  end
end
