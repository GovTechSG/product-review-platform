class IndustrySerializer < ActiveModel::Serializer
  attributes :id, :name, :description

  def id
    object.hashid
  end
end
