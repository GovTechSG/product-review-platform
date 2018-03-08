class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :review_id, :user_id
end
