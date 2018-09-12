class Project < Reviewable
  include SwaggerDocs::Project
  include Statistics::ProductsAndServices

  validates :name, :company, :reviews_count, presence: true
  validates :description, presence: true, allow_blank: true
end
