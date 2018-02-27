module SwaggerDocs::Grants
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/grants' do
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, ['grant']
        key :description, 'Returns list of all grants'
        key :operationId, 'findGrants'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, list of grants fetched'
          schema type: :array do
            items do
              key :'$ref', :Grant
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
        key :tags, ['grant']
        key :description, 'Creates a new grant'
        key :operationId, 'addGrant'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'Details of the grant to be created'
          key :required, true
          schema do
            key :'$ref', :GrantInput
          end
        end
        response 201 do
          key :description, 'OK, grant is successfully created'
          schema do
            key :'$ref', :Grant
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

    swagger_path '/api/v1/grants/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of grant'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :put do
        security do
          key :Authorization, []
        end
        key :tags, ['grant']
        key :description, 'Update a grant'
        key :operationId, 'updateGrant'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'New details of the grant to be updated'
          key :required, true
          schema do
            key :'$ref', :GrantInput
          end
        end
        response 200 do
          key :description, 'OK, grant is successfully updated'
          schema do
            key :'$ref', :Grant
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
        key :tags, ['grant']
        key :description, 'Returns a grant'
        key :operationId, 'findGrantById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, grant of the given ID fetched'
          schema do
            key :'$ref', :Grant
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
        key :tags, ['grant']
        key :description, 'Deletes a single grant'
        key :operationId, 'deleteGrant'
        response 204 do
          key :description, 'No content success. Grant of the given ID is deleted'
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
