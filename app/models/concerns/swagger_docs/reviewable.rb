module SwaggerDocs::Reviewable
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :Reviewable do
      key :type, :object
      key :required, [:id, :name, :description]

      property :id do
        key :type, :string
        key :example, "AbC123"
      end

      property :name do
        key :type, :string
        key :example, "Spring Frameworks"
      end

      property :description do
        key :type, :string
        key :example, "Spring frameworks was not developed in spring"
      end
    end
  end
end
