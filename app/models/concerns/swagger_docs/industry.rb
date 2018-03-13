module SwaggerDocs::Industry
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :Industry do
      key :type, :object
      key :required, [:id, :name]

      property :id do
        key :type, :integer
        key :format, :int64
      end

      property :name do
        key :type, :string
        key :example, 'Agriculture'
      end

      property :description do
        key :type, :string
        key :example, 'The agricultural industry, which includes enterprises engaged in growing crops, raising fish and animals, and logging wood, encompasses farms, dairies, hatcheries, and ranches.'
      end
    end

    swagger_schema :IndustryInput do
      allOf do
        schema do
          property :industry do
            key :type, :object
            property :name do
              key :type, :string
            end
            property :description do
              key :type, :string
            end
          end
        end
      end
    end
  end
end
