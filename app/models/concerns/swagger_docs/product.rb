module SwaggerDocs::Product
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :Product do
      key :type, :object
      key :required, [:id, :name, :description, :company]

      property :id do
        key :type, :string
        key :example, "AbC123"
      end

      property :name do
        key :type, :string
        key :example, "Postman Product"
      end

      property :description do
        key :type, :string
        key :example, "A postman API"
      end

      property :companies do
        key :type, :array
        items do
          key :'$ref', :CompanyAssociation
        end
      end

      property :reviews_count do
        key :type, :number
      end
    end

    swagger_schema :Product_Review do
      key :type, :object
      key :required, [:type, :id, :name, :description]

      property :type do
        key :type, :string
        key :example, "Product"
      end

      property :id do
        key :type, :string
        key :example, "AbC123"
      end

      property :name do
        key :type, :string
        key :example, "Postman Product"
      end

      property :description do
        key :type, :string
        key :example, "A postman API"
      end

      property :reviews_count do
        key :type, :number
      end
    end

    swagger_schema :ProductInput do
      allOf do
        schema do
          property :product do
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
