class Comment < ApplicationRecord
  include SwaggerDocs::Comment
  include Discard::Model
  belongs_to :user
  belongs_to :review

  validates_presence_of :content, :user, :review
end
