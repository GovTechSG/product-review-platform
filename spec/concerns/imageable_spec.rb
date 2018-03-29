require 'rails_helper'

shared_examples_for 'imageable' do
  let(:model) { build described_class.to_s.underscore }
  let(:valid_base64_image) { "data:image/png;base64," + Base64.encode64(Rack::Test::UploadedFile.new(Rails.root.join('spec/support/test_image.png')).read) }
  let(:partial_base64_image) { Base64.encode64(Rack::Test::UploadedFile.new(Rails.root.join('spec/support/test_image.png')).read) }

  describe "imageable" do
    it "generates a letterhead avatar when no image is given" do
      model.set_image!(nil)
      expect(model.valid?).to eq(true)
      expect(model.image.url =~ %r{/200.png$}).to_not eq(nil)
    end

    it "generates a thumb letterhead avatar when no image is given" do
      model.set_image!(nil)
      expect(model.valid?).to eq(true)
      expect(model.image.thumb.url =~ %r{/thumb_200.png$}).to_not eq(nil)
    end

    it "generates a image url when image is given" do
      model.set_image!(valid_base64_image)
      expect(model.valid?).to eq(true)
      company_name = model.name.gsub(/\s/, '_')
      expect(model.image.url =~ /#{company_name}(.*).png$/).to_not eq(nil)
    end

    it "generates a thumb url when image is given" do
      model.set_image!(valid_base64_image)
      expect(model.valid?).to eq(true)
      company_name = model.name.gsub(/\s/, '_')
      expect(model.image.thumb.url =~ /thumb_#{company_name}(.*).png$/).to_not eq(nil)
    end

    it "raises error when image format is not valid" do
      model.set_image!(partial_base64_image)
      expect(model.errors.count).to eq(1)
    end

    it "raises error when base64 string format is not valid" do
      model.set_image!("data:image/pdf;base64" + partial_base64_image)
      expect(model.errors.count).to eq(1)
    end

    it "raises error when base64 string data is not valid" do
      model.set_image!("data:image/png;base64" + "partial_base64_image")
      expect(model.errors.count).to eq(1)
    end

    it "raises error if the data passes the regex check even though it is not an image" do
      model.set_image!("a:b/c;" + "partial_base64_image")
      expect(model.errors.count).to eq(1)
    end

    it "raises error if the data passes the regex check even though the format is not specified" do
      model.set_image!("a:b/c;" + partial_base64_image)
      expect(model.errors.count).to eq(1)
    end
  end
end