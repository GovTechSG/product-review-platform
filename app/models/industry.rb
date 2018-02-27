class Industry < ApplicationRecord
  #include SwaggerDocs::Industry
  include Discard::Model

  has_many :industry_companies, dependent: :destroy
  has_many :companies, through: :industry_companies

  validates :name, presence: true
end
