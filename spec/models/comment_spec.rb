require 'rails_helper'
require 'concerns/statistics/reviews_spec.rb'

RSpec.describe Comment, type: :model do
  it_behaves_like "reviews"
end