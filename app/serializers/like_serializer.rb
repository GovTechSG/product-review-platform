class LikeSerializer < ActiveModel::Serializer
  attributes :id, :review_id, :user_id
end
