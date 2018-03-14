class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :review_id, :agency_id
end
