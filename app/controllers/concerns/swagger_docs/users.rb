module SwaggerDocs::Users
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/users' do
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, ['User']
        key :description, 'Returns list of all users'
        key :operationId, 'findUsers'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, list of agencies fetched'
          schema type: :array do
            items do
              key :'$ref', :User
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
        key :tags, ['User']
        key :description, 'Creates a new user'
        key :operationId, 'addUser'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'Details of User to be created'
          key :required, true
          schema do
            key :'$ref', :UserInput
          end
        end
        response 201 do
          key :description, 'OK, User is successfully created'
          schema do
            key :'$ref', :User
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

    swagger_path '/api/v1/users/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of user'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :put do
        security do
          key :Authorization, []
        end
        key :tags, ['User']
        key :description, 'Update an user'
        key :operationId, 'updateUser'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'New details of User to be updated'
          key :required, true
          schema do
            key :'$ref', :UserInput
          end
        end
        response 200 do
          key :description, 'OK, User is successfully updated'
          schema do
            key :'$ref', :User
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
        key :tags, ['User']
        key :description, 'Returns an user'
        key :operationId, 'findUserById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, user of the given ID fetched'
          schema do
            key :'$ref', :User
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
        key :tags, ['User']
        key :description, 'Deletes a single user'
        key :operationId, 'deleteUser'
        response 204 do
          key :description, 'No content success. User of the given ID is deleted'
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
