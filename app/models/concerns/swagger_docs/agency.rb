module SwaggerDocs::Agency
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :Agency do
      key :type, :object
      key :required, [:id, :name, :email, :number]

      property :id do
        key :type, :integer
        key :format, :int64
      end

      property :name do
        key :type, :string
      end

      property :email do
        key :type, :string
      end

      property :number do
        key :type, :string
      end
    end

    swagger_schema :AgencyInput do
      allOf do
        schema do
          property :agency do
            key :type, :object
            property :name do
              key :type, :string
              key :example, "[Enter the Agency name here. Example: SPRING Singapore]"
            end

            property :email do
              key :type, :string
              key :example, "[Enter the Agency email here. Example: agency_3@foo.com]"
            end

            property :number do
              key :type, :string
              key :example, "[Enter the Agency number here. Example: 71512234]"
            end
          end
        end
      end
    end
  end
end
