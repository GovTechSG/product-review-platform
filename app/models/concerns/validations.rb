module Validations
  def valid_email?
    errors.add(:email, "Invalid format") if !EmailAddress.valid? email
  end
end