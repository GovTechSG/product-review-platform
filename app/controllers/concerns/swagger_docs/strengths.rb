module SwaggerDocs::Strengths
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/strengths' do
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, ['Strength']
        key :description, 'Returns list of all strengths'
        key :operationId, 'findStrengths'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, list of strengths fetched'
          schema type: :array do
            items do
              key :'$ref', :Strength
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
        key :tags, ['Strength']
        key :description, 'Creates a new strength'
        key :operationId, 'addStrength'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'Details of the strength to be created'
          key :required, true
          schema do
            key :'$ref', :StrengthInput
          end
        end
        response 201 do
          key :description, 'OK, strength is successfully created'
          schema do
            key :'$ref', :Strength
          end
        end
        response 422 do
          key :'$ref', :SwaggerError
        end
        response 401 do
          key :'$ref', :UnauthorisedError
        end
        response 400 do
          key :'$ref', :BadRequestError
        end
      end
    end

    swagger_path '/api/v1/strengths/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of strength'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :put do
        security do
          key :Authorization, []
        end
        key :tags, ['Strength']
        key :description, 'Update a strength'
        key :operationId, 'updateStrength'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'New details of the strength to be updated'
          key :required, true
          schema do
            key :'$ref', :StrengthInput
          end
        end
        response 200 do
          key :description, 'OK, strength is successfully updated'
          schema do
            key :'$ref', :Strength
          end
        end
        response 422 do
          key :'$ref', :SwaggerError
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
        key :tags, ['Strength']
        key :description, 'Returns a strength'
        key :operationId, 'findStrengthById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, strength of the given ID fetched'
          schema do
            key :'$ref', :Strength
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
        key :tags, ['Strength']
        key :description, 'Deletes a single strength'
        key :operationId, 'deleteStrength'
        response 204 do
          key :description, 'No content success. Strength of the given ID is deleted'
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
