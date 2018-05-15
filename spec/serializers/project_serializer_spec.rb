require 'rails_helper'

RSpec.describe ProjectSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @project = create(:project)
    end

    subject { ProjectSerializer.new(@project, root: false).as_json["object"].merge("company" => @project.company) }

    it 'has a name' do
      expect(subject['name']).to eql(@project.name)
    end

    it 'has a company' do
      expect(subject['company']).to eql(@project.company)
    end

    it 'has a reviews_count' do
      expect(subject['reviews_count']).to eql(@project.reviews_count)
    end

    it 'has a description' do
      expect(subject['description']).to eql(@project.description)
    end
  end
end
