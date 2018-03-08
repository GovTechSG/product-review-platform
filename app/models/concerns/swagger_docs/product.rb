module SwaggerDocs::Product
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :Product do
      key :type, :object
      key :required, [:id, :name, :description, :company]

      property :id do
        key :type, :integer
        key :format, :int64
      end

      property :name do
        key :type, :string
        key :example, "Postman Product"
      end

      property :description do
        key :type, :string
        key :example, "A postman API"
      end

      property :company do
        key :'$ref', :Company
      end
    end

    swagger_schema :Product_Review do
      key :type, :object
      key :required, [:type, :id, :name, :description, :company]

      property :type do
        key :type, :string
        key :example, "Product"
      end

      property :id do
        key :type, :integer
        key :format, :int64
      end

      property :name do
        key :type, :string
        key :example, "Postman Product"
      end

      property :description do
        key :type, :string
        key :example, "A postman API"
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
