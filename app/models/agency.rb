class Agency < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates_presence_of :name, :email, :number

  include Swagger::Blocks

  swagger_schema :Agency do
    key :type, :object
    key :required, [:id, :name, :email, :number]

    property :id do
      key :type, :integer
      key :format, :int64
    end

    property :name do
      key :type, :string
    end

    property :email do
      key :type, :string
    end

    property :number do
      key :type, :string
    end
  end

  swagger_schema :AgencyInput do
    allOf do
      schema do
        property :agency do
          key :type, :object
          key :'$ref', :Agency
        end
      end
    end
  end
end
