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

      property :description do
        key :type, :string
      end
    end

    swagger_schema :CompanyInput do
      allOf do
        schema do
          property :company do
            key :type, :object
            property :name do
              key :type, :string
              key :example, "[Enter the company name here. Example: GovTech]"
            end

            property :UEN do
              key :type, :string
              key :example, "[Enter the UEN of the company here. Example: 987654321]"
            end

            property :aggregate_score do
              key :type, :number
              key :example, "[Enter the aggregate score of the company here. Example: 3]"
            end

            property :description do
              key :type, :string
              key :example, "[Enter the description of the company here]"
            end
          end
        end
      end
    end
    swagger_schema :SwaggerError do
      key :required, [:code, :message]
      property :code do
        key :type, :integer
        key :format, :int32
      end
      property :message do
        key :type, :string
      end
    end
  end
end
