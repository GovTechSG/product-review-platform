module SwaggerDocs::Statistics
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/statistics' do
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, [I18n.t('statistic.key').to_s]
        key :description, I18n.t('swagger_ui.index_description', model: "Statistic").to_s
        key :operationId, 'findStatistics'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, I18n.t('swagger_ui.index_success_description', model: "Statistic").to_s
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
        response 401 do
          key :'$ref', :UnauthorisedError
        end
      end
    end
  end
end
