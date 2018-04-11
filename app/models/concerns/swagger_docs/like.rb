module SwaggerDocs::Like
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :Like do
      key :type, :object
      key :required, [:id]

      property :id do
        key :type, :string
        key :example, "AbC123"
      end

      property :object do
        key :'$ref', :Review_Comment
      end

      property :from do
        key :'$ref', :Agency_Type
      end
    end

    swagger_schema :LikeInput do
      allOf do
        schema do
          property :like do
            key :type, :object
            property :from_id do
              key :type, :string
            end

            property :from_type do
              key :type, :string
            end
          end
        end
      end
    end
  end
end
