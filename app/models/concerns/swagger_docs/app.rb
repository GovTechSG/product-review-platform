module SwaggerDocs::App
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :Token do
      key :type, :object
      key :required, [:name, :password]

      property :access_token do
        key :type, :string
      end

      property :token_type do
        key :type, :string
      end

      property :created_at do
        key :type, :integer
      end
    end

    swagger_schema :TokenInput do
      allOf do
        schema do
          property :name do
            key :type, :string
          end

          property :password do
            key :type, :string
          end
        end
      end
    end

    swagger_schema :TokenRefreshInput do
      allOf do
        schema do
          property :token do
            key :type, :string
          end

          property :name do
            key :type, :string
          end

          property :password do
            key :type, :string
          end
        end
      end
    end

    swagger_schema :TokenSignoutInput do
      allOf do
        schema do
          property :token do
            key :type, :string
          end
        end
      end
    end
  end
end
