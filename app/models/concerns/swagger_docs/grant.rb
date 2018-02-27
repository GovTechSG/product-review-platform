module SwaggerDocs::Grant
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    # example :Grant do
    #   key :strength, ["Quality Tools & Materials", "Skillful & Knowledgeable"]
    # end

    swagger_schema :Grant do
      key :type, :object
      key :required, [:id, :name, :UEN, :aggregate_score]

      property :id do
        key :type, :integer
        key :format, :int64
      end

      property :name do
        key :type, :string
        key :example, 'Pivotal Software'
      end
    end

    swagger_schema :GrantInput do
      allOf do
        schema do
          property :grant do
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
