class Project < Reviewable
  include SwaggerDocs::Project
  include Statistics::ProductsAndServices

  belongs_to :company
  has_many :reviews, as: :reviewable, dependent: :destroy

  validates :name, :description, :company, :reviews_count, presence: true

  scope :kept, -> { undiscarded.joins(:company).merge(Company.kept) }

  def presence?
    !discarded? && company.presence?
  end
end
