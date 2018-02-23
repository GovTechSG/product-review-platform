class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :number
end
