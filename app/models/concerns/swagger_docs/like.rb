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

      property :review_id do
        key :type, :integer
        key :format, :int64
      end

      property :user_id do
        key :type, :integer
        key :format, :int64
      end
    end

    swagger_schema :LikeInput do
      allOf do
        schema do
          property :like do
            key :type, :object
            property :user_id do
              key :type, :integer
              key :format, :int64
            end
          end
        end
      end
    end
  end
end
