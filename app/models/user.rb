class User < ActiveRecord::Base
  # Include default devise modules.
  # :omniauthable, :rememberable
  devise :database_authenticatable, :registerable,
          :recoverable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
end
