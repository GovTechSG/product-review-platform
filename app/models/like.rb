class Like < ApplicationRecord
  include SwaggerDocs::Like
  include Discard::Model
  belongs_to :user
  belongs_to :review

  validates_presence_of :user, :review
  validates :review_id, uniqueness: { scope: :user_id }
end
