class Project < Reviewable
  include SwaggerDocs::Project
  include Statistics::ProductsAndServices

  validates :name, :description, :company, :reviews_count, presence: true
end
