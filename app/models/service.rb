class Service < Reviewable
  include SwaggerDocs::Service
  include Statistics::ProductsAndServices

  validates_presence_of :name, :description, :company, :reviews_count
end
