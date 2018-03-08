class GrantSerializer < ActiveModel::Serializer
  attributes :id, :name, :acronym, :description

  belongs_to :user, serializer: UserSerializer
end
