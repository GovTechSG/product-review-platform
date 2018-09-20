require 'rails_helper'

RSpec.describe ProjectSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    before(:all) do
      @project = create(:project)
      @project.companies.create!(build(:company_as_params))
    end

    subject { ProjectSerializer.new(@project, root: false).as_json["object"].merge("companies" => @project.companies) }

    it 'has a name' do
      expect(subject['name']).to eql(@project.name)
    end

    it 'has companies' do
      expect(subject['companies']).to eql(@project.companies)
    end

    it 'has a reviews_count' do
      expect(subject['reviews_count']).to eql(@project.reviews_count)
    end

    it 'has a description' do
      expect(subject['description']).to eql(@project.description)
    end
  end
end
