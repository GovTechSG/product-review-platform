module SwaggerDocs::Strength
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    # example :Strength do
    #   key :strength, ["Quality Tools & Materials", "Skillful & Knowledgeable"]
    # end

    swagger_schema :Strength do
      key :type, :object
      key :required, [:id, :name, :description]

      property :id do
        key :type, :integer
        key :format, :int64
      end

      property :name do
        key :type, :string
        key :example, 'Reliability'
      end

      property :description do
        key :type, :string
        key :example, 'The ability to deliver the promised product or service in a consistent and accurate manner.'
      end
    end

    swagger_schema :StrengthInput do
      allOf do
        schema do
          property :strength do
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
