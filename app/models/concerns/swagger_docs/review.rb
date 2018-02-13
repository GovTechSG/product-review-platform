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
        key :example, "Spring frameworks was not developed in spring"
      end

      property :company_id do
        key :type, :integer
        key :format, :int64
      end

      property :reviewable_type do
        key :type, :string
        key :example, "Product"
      end

      property :reviewable_id do
        key :type, :integer
        key :format, :int64
      end

      property :strengths do
        key :type, :array
        items do
          key :type, :string
          key :example, [
              "Reliable",
              "Explanation of Resources"
          ]
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
              key :example, "[Enter the score for the Review. Example: 3]"
            end

            property :content do
              key :type, :string
              key :example, "[Enter the content for the Review. Example: A postman API is good]"
            end

            property :strengths do
              key :type, :array
              items do
                key :type, :string
                key :example, "[Enter the review strengths here] Example: 'Reliable','Good Performance' "
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
              key :example, "[Enter the score for the Review. Example: 3]"
            end

            property :content do
              key :type, :string
              key :example, "[Enter the content for the Review. Example: A postman API is good]"
            end

            property :company_id do
              key :type, :integer
              key :format, :int64
              key :example, "[Enter the review Company ID here. Example: 1]"
            end

            property :strengths do
              key :type, :array
              items do
                key :type, :string
                key :example, "[Enter the review strengths here] Example: 'Reliable','Good Performance' "
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
              key :example, "[Enter the score for the Review. Example: 3]"
            end

            property :content do
              key :type, :string
              key :example, "[Enter the content for the Review. Example: A postman API is good]"
            end

            property :company_id do
              key :type, :integer
              key :format, :int64
              key :example, "[Enter the review Company ID here. Example: 1]"
            end

            property :strengths do
              key :type, :array
              items do
                key :type, :string
                key :example, "[Enter the review strengths here] Example: 'Reliable','Good Performance' "
              end
            end
          end
        end
      end
    end
  end
end
