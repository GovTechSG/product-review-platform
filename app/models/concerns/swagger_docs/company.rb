module SwaggerDocs::Company
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :Company do
      key :type, :object
      key :required, [:id, :name, :uen, :aggregate_score]

      property :id do
        key :type, :string
        key :example, "AbC123"
      end

      property :name do
        key :type, :string
        key :example, 'Pivotal Software'
      end

      property :uen do
        key :type, :string
        key :example, '984208875'
      end

      property :phone_number do
        key :type, :string
        key :example, '+1 (415) 777-4868'
      end

      property :url do
        key :type, :string
        key :example, 'https://pivotal.io/'
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

      property :image do
        key :type, :object
        property :url do
          key :type, :string
          key :example, "https://review-api.gds-gov.tech/uploads/company/image/24/pivotal20180402-93182-7x7gd.gif"
        end
        property :thumb do
          key :type, :object
          property :url do
            key :type, :string
            key :example, "https://review-api.gds-gov.tech/uploads/company/image/24/thumb_pivotal20180402-93182-7x7gd.gif"
          end
        end
      end

      property :aspects do
        key :type, :array
        items do
          key :'$ref', :Aspect
        end
      end

      property :industries do
        key :type, :array
        items do
          key :'$ref', :Industry
        end
      end
    end

    swagger_schema :VendorListing do
      key :type, :object
      key :required, [:id, :name, :uen, :aggregate_score]

      property :id do
        key :type, :string
        key :example, "AbC123"
      end

      property :name do
        key :type, :string
        key :example, 'Pivotal Software'
      end

      property :aggregate_score do
        key :type, :number
      end

      property :reviews_count do
        key :type, :number
      end

      property :image do
        key :type, :object
        property :url do
          key :type, :string
          key :example, "https://review-api.gds-gov.tech/uploads/company/image/24/pivotal20180402-93182-7x7gd.gif"
        end
        property :thumb do
          key :type, :object
          property :url do
            key :type, :string
            key :example, "https://review-api.gds-gov.tech/uploads/company/image/24/thumb_pivotal20180402-93182-7x7gd.gif"
          end
        end
      end

      property :industries do
        key :type, :array
        items do
          key :'$ref', :Industry
        end
      end

      property :projects do
        key :type, :array
        items do
          key :'$ref', :Industry
        end
      end
    end

    swagger_schema :CompanyAssociation do
      key :type, :object
      key :required, [:id, :name, :uen, :aggregate_score]

      property :type do
        key :type, :string
        key :example, 'Company'
      end

      property :id do
        key :type, :string
        key :example, "AbC123"
      end

      property :name do
        key :type, :string
        key :example, 'Pivotal Software'
      end

      property :uen do
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

      property :image do
        key :type, :object
        property :url do
          key :type, :string
          key :example, "https://review-api.gds-gov.tech/uploads/company/image/24/pivotal20180402-93182-7x7gd.gif"
        end
        property :thumb do
          key :type, :object
          property :url do
            key :type, :string
            key :example, "https://review-api.gds-gov.tech/uploads/company/image/24/thumb_pivotal20180402-93182-7x7gd.gif"
          end
        end
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

            property :uen do
              key :type, :string
            end

            property :description do
              key :type, :string
            end

            property :phone_number do
              key :type, :string
            end

            property :url do
              key :type, :string
            end

            property :image do
              key :type, :string
              key :format, :byte
            end

            property :industry_ids do
              key :type, :array
              items do
                key :type, :string
              end
            end
          end
        end
      end
    end

    swagger_schema :CompanySearchInput do
      allOf do
        schema do
          property :user do
            key :type, :object
            property :name do
              key :type, :string
            end

            property :uen do
              key :type, :string
            end

            property :description do
              key :type, :string
            end

            property :phone_number do
              key :type, :string
            end

            property :url do
              key :type, :string
            end

            property :image do
              key :type, :string
              key :format, :byte
            end

            property :industry_ids do
              key :type, :array
              items do
                key :type, :string
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
