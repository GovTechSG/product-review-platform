module SwaggerDocs::Comment
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :Comment do
      key :type, :object
      key :required, [:id, :content, :agency_id, :review_id]

      property :id do
        key :type, :integer
        key :format, :int64
      end

      property :content do
        key :type, :string
      end

      property :agency_id do
        key :type, :integer
        key :format, :int64
      end

      property :review_id do
        key :type, :integer
        key :format, :int64
      end
    end

    swagger_schema :CommentCreateInput do
      allOf do
        schema do
          property :comment do
            key :type, :object
            property :content do
              key :type, :string
            end

            property :agency_id do
              key :type, :integer
              key :format, :int64
            end
          end
        end
      end
    end

    swagger_schema :CommentUpdateInput do
      allOf do
        schema do
          property :comment do
            key :type, :object
            property :content do
              key :type, :string
            end
          end
        end
      end
    end
  end
end