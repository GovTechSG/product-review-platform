class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content
  belongs_to :commentable, key: "object", serializer: ReviewSerializer, if: :review?
  belongs_to :commenter, key: "from", serializer: AgencySerializer, if: :agency?

  def review?
    object.commentable.class == Review
  end

  def agency?
    object.commenter.class == Agency
  end

end
