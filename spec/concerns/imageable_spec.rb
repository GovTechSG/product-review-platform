require 'rails_helper'

shared_examples_for 'imageable' do
  let(:model) { create described_class.to_s.underscore }
  
  
end