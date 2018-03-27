class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content

  belongs_to :commentable, key: "object", polymorphic: true
  belongs_to :commenter, key: "from", polymorphic: true
end
