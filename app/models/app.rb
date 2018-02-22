class App < ApplicationRecord
  include SwaggerDocs::App
  include Discard::Model
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         authentication_keys: [:name]

  validates :name, presence: true, uniqueness: true
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end

  def discard
    super
    @existing_token = Doorkeeper::AccessToken.find_by(resource_owner_id: id, revoked_at: nil)
    if @existing_token
      @existing_token.revoked_at = Time.current
      @existing_token.save
    end
  end

  class << self
    def authenticate(name, password)
      app = App.find_for_authentication(name: name)
      if app.nil? || app.discarded?
        nil
      else
        app.try(:valid_password?, password) ? app : nil
      end
    end
  end
end
