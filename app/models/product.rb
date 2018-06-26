class Product < Reviewable
  include SwaggerDocs::Product
  include Statistics::ProductsAndServices

  validates_presence_of :name, :description, :company, :reviews_count
end
