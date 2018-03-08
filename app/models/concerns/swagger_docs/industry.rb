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
        key :example, 'Finance'
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
          end
        end
      end
    end
  end
end
