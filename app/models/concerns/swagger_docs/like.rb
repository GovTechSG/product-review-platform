module SwaggerDocs::Like
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :Like do
      key :type, :object
      key :required, [:id, :user_id, :review_id]

      property :id do
        key :type, :integer
        key :format, :int64
      end

      property :user_id do
        key :type, :integer
        key :format, :int64
      end

      property :review_id do
        key :type, :integer
        key :format, :int64
      end
    end

    swagger_schema :LikeInput do
      allOf do
        schema do
          property :user_id do
            key :type, :integer
            key :format, :int64
            key :example, "[Enter the User ID to be liked here. Example: 4]"
          end
        end
      end
    end
  end
end
