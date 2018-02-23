module SwaggerDocs::Service
  extend ActiveSupport::Concern

  included do
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
        key :example, "Spring Frameworks"
      end

      property :description do
        key :type, :string
        key :example, "Spring frameworks was not developed in spring"
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
          end
        end
      end
    end
  end
end
