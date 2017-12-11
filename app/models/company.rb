class Company < ApplicationRecord
  has_many :products
  has_many :services
end
