module SwaggerDocs::Company
  extend ActiveSupport::Concern

  included do
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
        end
      end
    end
  end
end