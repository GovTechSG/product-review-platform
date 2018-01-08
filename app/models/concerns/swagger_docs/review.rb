module SwaggerDocs::Review
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :Review do
      key :type, :object
      key :required, [:id, :score, :content, :company_id, :reviewable_id]

      property :id do
        key :type, :integer
        key :format, :int64
      end

      property :score do
        key :type, :number
      end

      property :content do
        key :type, :string
      end

      property :company_id do
        key :type, :integer
        key :format, :int64
      end

      property :reviewable_type do
        key :type, :string
      end

      property :reviewable_id do
        key :type, :integer
        key :format, :int64
      end

      property :strengths do
        key :type, :array
        items do
          key :type, :string
        end
      end
    end

    swagger_schema :ReviewInput do
      allOf do
        schema do
          property :review do
            key :type, :object
            property :score do
              key :type, :number
            end

            property :content do
              key :type, :string
            end

            property :strengths do
              key :type, :array
              items do
                key :type, :string
              end
            end
          end
        end
      end
    end

    swagger_schema :ProductReviewInput do
      allOf do
        schema do
          property :review do
            key :type, :object
            property :score do
              key :type, :number
            end

            property :content do
              key :type, :string
            end

            property :company_id do
              key :type, :integer
              key :format, :int64
            end

            property :strengths do
              key :type, :array
              items do
                key :type, :string
              end
            end
          end
        end
      end
    end

      swagger_schema :ServiceReviewInput do
      allOf do
        schema do
          property :review do
            key :type, :object
            property :score do
              key :type, :number
            end

            property :content do
              key :type, :string
            end

            property :company_id do
              key :type, :integer
              key :format, :int64
            end

            property :strengths do
              key :type, :array
              items do
                key :type, :string
              end
            end
          end
        end
      end
    end
  end
end