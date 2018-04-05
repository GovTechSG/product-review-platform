class ApplicationRecord < ActiveRecord::Base
  include Discard::Model
  include Hashid::Rails
  self.abstract_class = true

  def presence?
    !discarded?
  end
end
