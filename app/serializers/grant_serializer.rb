class GrantSerializer < ActiveModel::Serializer
  attributes :id, :name, :description

  belongs_to :user, serializer: UserSerializer
end
