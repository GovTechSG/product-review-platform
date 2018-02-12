module SwaggerDocs::App
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :Token do
      key :type, :object
      key :required, [:name, :password]

      property :name do
        key :type, :string
      end

      property :password do
        key :type, :string
      end
    end

    swagger_schema :TokenInput do
      allOf do
        schema do
          property :name do
            key :type, :string
            key :example, "[Enter username here]"
          end

          property :password do
            key :type, :string
            key :example, "[Enter password here]"
          end
        end
      end
    end
  end
end
