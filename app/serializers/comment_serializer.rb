class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content
  belongs_to :commentable, key: "object", serializer: ReviewSerializer, if: :review?
  belongs_to :commenter, key: "from", serializer: AgencySerializer, if: :agency?

  def review?
    instance_options[:commentable].class == Review
  end

  def agency?
    instance_options[:commentable].comments.pluck("commenter_type").each do |commenter| commenter == "Agency" end
  end

end
