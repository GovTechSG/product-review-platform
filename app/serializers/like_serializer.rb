class LikeSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :likeable, key: "object", polymorphic: true
  belongs_to :liker, key: "from", polymorphic: true
end
