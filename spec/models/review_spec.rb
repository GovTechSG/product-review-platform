require 'rails_helper'
require 'concerns/statistics/reviews_spec.rb'

RSpec.describe Review, type: :model do
  it_behaves_like "reviews"
end