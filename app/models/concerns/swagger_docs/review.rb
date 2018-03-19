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

      property :strengths do
        key :type, :array
        key :'$ref', :Strength
      end

      property :object do
        key :'$ref', :Product_Review
      end

      property :reviewer do
        key :'$ref', :Company
      end

      property :grant do
        key :'$ref', :ReviewGrant
      end
    end

    swagger_schema :Review_Service do
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

      property :strengths do
        key :type, :array
        key :example, "Spring frameworks was not developed in spring"
      end

      property :object do
        key :'$ref', :Service_Review
      end

      property :reviewer do
        key :'$ref', :Company
      end

      property :grant do
        key :'$ref', :ReviewGrant
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

            property :strength_ids do
              key :type, :array
              items do
                key :type, :integer
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

            property :reviewer_id do
              key :type, :integer
              key :format, :int64
            end

            property :grant_id do
              key :type, :integer
              key :format, :int64
            end

            property :strength_ids do
              key :type, :array
              items do
                key :type, :integer
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

            property :reviewer_id do
              key :type, :integer
              key :format, :int64
            end

            property :grant_id do
              key :type, :integer
              key :format, :int64
            end

            property :strength_ids do
              key :type, :array
              items do
                key :type, :integer
              end
            end
          end
        end
      end
    end
  end
end
