module SwaggerDocs::Industry
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :Industry do
      key :type, :object
      key :required, [:id, :name]

      property :id do
        key :type, :integer
        key :format, :int64
      end

      property :name do
        key :type, :string
        key :example, 'Finance'
      end
    end

    swagger_schema :IndustryInput do
      allOf do
        schema do
          property :industry do
            key :type, :object
            property :name do
              key :type, :string
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

    swagger_schema :NotFoundError do
      key :description, 'Not found. Given ID is invalid/not found'
    end

    swagger_schema :UnauthorisedError do
      key :description, 'Unauthorized. Missing or invalid credentials. Please sign in/sign up first.'
    end

    swagger_schema :BadRequestError do
      key :description, 'Bad Request. Params is missing'
    end
  end
end
