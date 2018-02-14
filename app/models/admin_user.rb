class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include Discard::Model
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         authentication_keys: [:email]
end
