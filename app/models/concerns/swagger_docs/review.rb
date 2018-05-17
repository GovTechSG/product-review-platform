module SwaggerDocs::Review
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :Review do
      key :type, :object
      key :required, [:id, :score, :content, :company_id, :reviewable_id]

      property :id do
        key :type, :string
        key :example, "AbC123"
      end

      property :score do
        key :type, :number
      end

      property :content do
        key :type, :string
        key :example, "Spring frameworks was not developed in spring"
      end

      property :object do
        key :'$ref', :Product_Review
      end

      property :from do
        key :'$ref', :CompanyAssociation
      end

      property :grant do
        key :'$ref', :ReviewGrant
      end

      property :aspects do
        key :type, :array
        items do
          key :'$ref', :Aspect
        end
      end
    end

    swagger_schema :Review_Comment do
      key :type, :object
      key :required, [:id, :score, :content, :company_id, :reviewable_id]

      property :type do
        key :type, :string
        key :example, 'Review'
      end

      property :id do
        key :type, :string
        key :example, "AbC123"
      end

      property :score do
        key :type, :number
      end

      property :content do
        key :type, :string
        key :example, "Spring frameworks was not developed in spring"
      end
    end

    swagger_schema :Review_Service do
      key :type, :object
      key :required, [:id, :score, :content, :company_id, :reviewable_id]

      property :id do
        key :type, :string
        key :example, "AbC123"
      end

      property :score do
        key :type, :number
      end

      property :content do
        key :type, :string
        key :example, "Spring frameworks was not developed in spring"
      end

      property :object do
        key :'$ref', :Service_Review
      end

      property :from do
        key :'$ref', :CompanyAssociation
      end

      property :grant do
        key :'$ref', :ReviewGrant
      end

      property :aspects do
        key :type, :array
        items do
          key :'$ref', :Aspect
        end
      end
    end

    swagger_schema :Review_Project do
      key :type, :object
      key :required, [:id, :score, :content, :company_id, :reviewable_id]

      property :id do
        key :type, :string
        key :example, "AbC123"
      end

      property :score do
        key :type, :number
      end

      property :content do
        key :type, :string
        key :example, "Spring frameworks was not developed in spring"
      end

      property :object do
        key :'$ref', :Project_Review
      end

      property :from do
        key :'$ref', :CompanyAssociation
      end

      property :grant do
        key :'$ref', :ReviewGrant
      end

      property :aspects do
        key :type, :array
        items do
          key :'$ref', :Aspect
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

            property :from_id do
              key :type, :string
            end

            property :from_type do
              key :type, :string
            end

            property :grant_id do
              key :type, :string
            end
            property :aspect_ids do
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

            property :from_id do
              key :type, :string
            end

            property :from_type do
              key :type, :string
            end

            property :grant_id do
              key :type, :string
            end

            property :aspect_ids do
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

            property :from_id do
              key :type, :string
            end

            property :from_type do
              key :type, :string
            end

            property :grant_id do
              key :type, :string
            end

            property :aspect_ids do
              key :type, :array
              items do
                key :type, :string
              end
            end
          end
        end
      end
    end

    swagger_schema :ProjectReviewInput do
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

            property :from_id do
              key :type, :string
            end

            property :from_type do
              key :type, :string
            end

            property :grant_id do
              key :type, :string
            end

            property :aspect_ids do
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
