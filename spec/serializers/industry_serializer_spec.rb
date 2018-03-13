require 'rails_helper'

RSpec.describe IndustrySerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @industry = create(:industry)
    end

    subject { IndustrySerializer.new(@industry, root: false).as_json["object"] }

    it 'has a name' do
      expect(subject['name']).to eql(@industry.name)
    end

    it 'has a description' do
      expect(subject['description']).to eql(@industry.description)
    end
  end
end
