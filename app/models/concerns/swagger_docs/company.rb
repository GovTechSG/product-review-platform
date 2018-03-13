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
        key :example, 'Pivotal Software'
      end

      property :UEN do
        key :type, :string
        key :example, '984208875'
      end

      property :aggregate_score do
        key :type, :number
      end

      property :description do
        key :type, :string
        key :example, 'Vestibulum nec turpis vestibulum, feugiat mi at, egestas ex. Proin non enim mollis.'
      end

      property :reviews_count do
        key :type, :number
      end

      property :strengths do
        key :type, :array
        key :example, ["Quality Tools & Materials", "Skillful & Knowledgeable"]
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

            property :description do
              key :type, :string
            end
            property :industry_ids do
              key :type, :array
              items do
                key :type, :integer
              end
            end
          end
        end
      end
    end

    swagger_schema :SwaggerError do
      key :description, 'Unprocessable Entity'
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
