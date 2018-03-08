module SwaggerDocs::Industries
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/industries' do
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, ['Industry']
        key :description, 'Returns list of all industries'
        key :operationId, 'findIndustries'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, list of industries fetched'
          schema type: :array do
            items do
              key :'$ref', :Industry
            end
          end
        end
        response 401 do
          key :'$ref', :UnauthorisedError
        end
      end
      operation :post do
        security do
          key :Authorization, []
        end
        key :tags, ['industry']
        key :description, 'Creates a new industry'
        key :operationId, 'addIndustry'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'Details of the industry to be created'
          key :required, true
          schema do
            key :'$ref', :IndustryInput
          end
        end
        response 201 do
          key :description, 'OK, industry is successfully created'
          schema do
            key :'$ref', :Industry
          end
        end
        response 422 do
          key :description, 'Unprocessable Entity'
          schema do
            key :'$ref', :SwaggerError
          end
        end
        response 401 do
          key :'$ref', :UnauthorisedError
        end
        response 400 do
          key :'$ref', :BadRequestError
        end
      end
    end

    swagger_path '/api/v1/industries/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of industry'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :put do
        security do
          key :Authorization, []
        end
        key :tags, ['industry']
        key :description, 'Update a industry'
        key :operationId, 'updateIndustry'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'New details of the industry to be updated'
          key :required, true
          schema do
            key :'$ref', :IndustryInput
          end
        end
        response 200 do
          key :description, 'OK, industry is successfully updated'
          schema do
            key :'$ref', :Industry
          end
        end
        response 422 do
          key :description, 'Unprocessable Entity'
          schema do
            key :'$ref', :SwaggerError
          end
        end
        response 401 do
          key :'$ref', :UnauthorisedError
        end
        response 404 do
          key :'$ref', :NotFoundError
        end
        response 400 do
          key :'$ref', :BadRequestError
        end
      end
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, ['industry']
        key :description, 'Returns a industry'
        key :operationId, 'findIndustryById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, industry of the given ID fetched'
          schema do
            key :'$ref', :Industry
          end
        end
        response 401 do
          key :'$ref', :UnauthorisedError
        end
        response 404 do
          key :'$ref', :NotFoundError
        end
      end
      operation :delete do
        security do
          key :Authorization, []
        end
        key :tags, ['industry']
        key :description, 'Deletes a single industry'
        key :operationId, 'deleteIndustry'
        response 204 do
          key :description, 'No content success. Industry of the given ID is deleted'
        end
        response 401 do
          key :'$ref', :UnauthorisedError
        end
        response 404 do
          key :'$ref', :NotFoundError
        end
      end
    end
  end
end
