class Project < Reviewable
  include SwaggerDocs::Project
  include Statistics::ProductsAndServices

  belongs_to :company
  has_many :reviews, as: :reviewable, dependent: :destroy

  validates :name, :description, :company, :reviews_count, presence: true

  scope :kept, -> { undiscarded.joins(:company).merge(Company.kept) }

  after_save :set_reviews_count, on: [:update]

  def set_reviews_count
    company.reviews_count -= reviews_count if discarded?
    company.save
  end

  def presence?
    !discarded? && company.presence?
  end
end
