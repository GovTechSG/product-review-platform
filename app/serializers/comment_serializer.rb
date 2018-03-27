class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content
  # belongs_to :commentable, key: "object", serializer: ReviewSerializer, if: :review?
  # belongs_to :commenter, key: "from", serializer: AgencySerializer, if: :agency?

  belongs_to :commentable, key: "object", polymorphic: true
  belongs_to :commenter, key: "from", polymorphic: true
end
