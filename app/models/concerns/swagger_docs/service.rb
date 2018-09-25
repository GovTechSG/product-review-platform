module SwaggerDocs::Service
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :Service do
      key :type, :object
      key :required, [:id, :name, :description, :company]

      property :id do
        key :type, :string
        key :example, "AbC123"
      end

      property :name do
        key :type, :string
        key :example, "Spring Frameworks"
      end

      property :description do
        key :type, :string
        key :example, "Spring frameworks was not developed in spring"
      end

      property :reviews_count do
        key :type, :number
      end

      property :companies do
        key :type, :array
        items do
          key :'$ref', :CompanyAssociation
        end
      end
    end

    swagger_schema :Service_Review do
      key :type, :object
      key :required, [:id, :name, :description, :company]

      property :type do
        key :type, :string
        key :example, "Service"
      end

      property :id do
        key :type, :string
        key :example, "AbC123"
      end

      property :name do
        key :type, :string
        key :example, "Spring Frameworks"
      end

      property :description do
        key :type, :string
        key :example, "Spring frameworks was not developed in spring"
      end

      property :reviews_count do
        key :type, :number
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
