class Service < Reviewable
  include SwaggerDocs::Service
  include Statistics::ProductsAndServices

  belongs_to :company
  has_many :reviews, as: :reviewable, dependent: :destroy

  validates_presence_of :name, :description, :company, :reviews_count

  scope :kept, -> { undiscarded.joins(:company).merge(Company.kept) }

  def presence?
    !discarded? && company.presence?
  end
end
