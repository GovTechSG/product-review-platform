class Service < Reviewable
  include SwaggerDocs::Service
  has_many :companies, through: :company_reviewables, as: :reviewable

  validates_presence_of :name, :description, :reviews_count
  validates :description, presence: true, allow_blank: true
end
