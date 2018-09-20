class Project < Reviewable
  include SwaggerDocs::Project
  has_many :company_reviewable, as: :reviewable, dependent: :destroy
  has_many :companies, through: :company_reviewable, as: :reviewable

  validates :name, :reviews_count, presence: true
  validates :description, presence: true, allow_blank: true
end
