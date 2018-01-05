module SwaggerDocs::Statistics
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/statistics' do
      operation :get do
        key :tags, ['statistics']
        key :description, 'Returns some general statistics about the app'
        key :operationId, 'findStatistics'
        key :produces, [
          'application/json'
        ]
        response 200 do
          schema do
            property :reviews do
              key :type, :integer
            end

            property :companies do
              key :type, :integer
            end

            property :products do
              key :type, :integer
            end

            property :services do
              key :type, :integer
            end
          end

        end
      end
    end
  end
end