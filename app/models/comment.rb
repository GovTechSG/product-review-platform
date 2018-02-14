class Comment < ApplicationRecord
  include SwaggerDocs::Comment
  include Discard::Model
  belongs_to :agency
  belongs_to :review

  validates_presence_of :content, :agency, :review
end
