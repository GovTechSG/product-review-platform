class Comment < ApplicationRecord
  include SwaggerDocs::Comment

  belongs_to :agency
  belongs_to :review

  validates_presence_of :content, :agency, :review
end
