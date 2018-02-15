class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :company_id, :description
end
