module SwaggerDocs::Agency
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :Agency do
      key :type, :object
      key :required, [:id, :name, :email, :phone_number]

      property :id do
        key :type, :integer
        key :format, :int64
      end

      property :name do
        key :type, :string
        key :example, "Ministry of Communications and Information"
      end

      property :email do
        key :type, :string
        key :example, "MCI_Connects@mci.gov.sg"
      end

      property :phone_number do
        key :type, :string
        key :example, "1800-8379655"
      end

      property :kind do
        key :type, :string
        key :example, "Ministry"
      end

      property :acronym do
        key :type, :string
        key :example, "MCI"
      end

      property :description do
        key :type, :string
        key :example, "The Ministry of Communications and Information (MCI) oversees the development of the infocomm technology, cyber security, media and design sectors; the national library, national archives and public libraries; as well as Government’s information and public communication policies. MCI’s mission is to connect our people to community, government and opportunity, enabled by trustworthy infrastructure and technology."
      end

      property :image do
        key :type, :object
        property :url do
          key :type, :string
          key :example, "https://review-api.gds-gov.tech/uploads/agency/image/24/mindef20180402-93182-7x7gd.gif"
        end
        property :thumb do
          key :type, :object
          property :url do
            key :type, :string
            key :example, "https://review-api.gds-gov.tech/uploads/agency/image/24/thumb_mindef20180402-93182-7x7gd.gif"
          end
        end
      end
    end

    swagger_schema :Agency_Comment do
      key :type, :object
      key :required, [:id, :name, :email, :phone_number]

      property :type do
        key :type, :string
        key :example, 'Agency'
      end

      property :id do
        key :type, :integer
        key :format, :int64
      end

      property :name do
        key :type, :string
        key :example, "Ministry of Communications and Information"
      end

      property :email do
        key :type, :string
        key :example, "MCI_Connects@mci.gov.sg"
      end

      property :phone_number do
        key :type, :string
        key :example, "1800-8379655"
      end

      property :kind do
        key :type, :string
        key :example, "Ministry"
      end

      property :acronym do
        key :type, :string
        key :example, "MCI"
      end

      property :description do
        key :type, :string
        key :example, "The Ministry of Communications and Information (MCI) oversees the development of the infocomm technology, cyber security, media and design sectors; the national library, national archives and public libraries; as well as Government’s information and public communication policies. MCI’s mission is to connect our people to community, government and opportunity, enabled by trustworthy infrastructure and technology."
      end

      property :image do
        key :type, :object
        property :url do
          key :type, :string
          key :example, "https://review-api.gds-gov.tech/uploads/agency/image/24/mindef20180402-93182-7x7gd.gif"
        end
        property :thumb do
          key :type, :object
          property :url do
            key :type, :string
            key :example, "https://review-api.gds-gov.tech/uploads/agency/image/24/thumb_mindef20180402-93182-7x7gd.gif"
          end
        end
      end
    end

    swagger_schema :AgencyInput do
      allOf do
        schema do
          property :agency do
            key :type, :object
            property :name do
              key :type, :string
            end

            property :email do
              key :type, :string
            end

            property :phone_number do
              key :type, :string
            end

            property :acronym do
              key :type, :string
            end

            property :kind do
              key :type, :string
            end

            property :description do
              key :type, :string
            end

            property :image do
              key :type, :string
            end
          end
        end
      end
    end
  end
end