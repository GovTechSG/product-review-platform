module SwaggerDocs::User
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :User do
      key :type, :object
      key :required, [:id, :name, :email, :number]

      property :id do
        key :type, :integer
        key :format, :int64
      end

      property :name do
        key :type, :string
        key :example, "MTI"
      end

      property :email do
        key :type, :string
        key :example, "user_1@foo.com"
      end

      property :number do
        key :type, :string
        key :example, "51512234"
      end
    end

    swagger_schema :UserInput do
      allOf do
        schema do
          property :user do
            key :type, :object
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
        end
      end
    end
  end
end
