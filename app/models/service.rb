class Service < ApplicationRecord
  belongs_to :company
  has_many :reviews, as: :reviewable, dependent: :destroy

  validates_presence_of :name, :description, :company

  include Swagger::Blocks

  swagger_schema :Service do
    key :type, :object
    key :required, [:id, :name, :description, :company_id]

    property :id do
      key :type, :integer
      key :format, :int64
    end

    property :name do
      key :type, :string
    end

    property :description do
      key :type, :string
    end

    property :company_id do
      key :type, :integer
      key :format, :int64
    end
  end

  swagger_schema :ServiceInput do
    allOf do
      schema do
        property :service do
          key :type, :object
          property :name do
            key :type, :string
          end

          property :description do
            key :type, :string
          end

          property :company_id do
            key :type, :integer
            key :format, :int64
          end
        end
      end
    end
  end
end
