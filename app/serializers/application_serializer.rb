class ApplicationSerializer < ActiveModel::Serializer
  def id
    object.hashid
  end
end
