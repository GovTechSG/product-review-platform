class ReviewSerializer < ActiveModel::Serializer
  attribute :type, if: :type?
  attributes :id, :score, :content
  belongs_to :reviewable, key: "object", polymorphic: true
  belongs_to :reviewer, key: "from", polymorphic: true
  belongs_to :grant, serializer: GrantSerializer
  has_many :aspects, serializer: AspectSerializer

  def type
    "Review"
  end

  def type?
    if instance_options[:has_type]
      false
    elsif instance_options[:has_type].nil?
      true
    end
  end

  def self.serializer_for(model, options)
    return AssociateCompanySerializer if model.class.name == I18n.t('company.key').to_s
    super
  end
end
