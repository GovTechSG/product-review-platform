class Company < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :services, dependent: :destroy

  validates_presence_of :name, :UEN, :aggregate_score

  include Swagger::Blocks

  swagger_schema :Company do
    key :type, :object
    key :required, [:id, :name, :UEN, :aggregate_score]

    property :id do
      key :type, :integer
      key :format, :int64
    end

    property :name do
      key :type, :string
    end

    property :UEN do
      key :type, :string
    end

    property :aggregate_score do
      key :type, :number
    end
  end

  swagger_schema :CompanyInput do
    allOf do
      schema do
        property :company do
          key :type, :object
          key :'$ref', :Company
        end
      end
    end
  end
end
