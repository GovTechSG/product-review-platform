module SwaggerDocs::Users
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/users' do
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, ['user']
        key :description, 'Returns list of all users'
        key :operationId, 'findUsers'
        key :produces, [
          'application/json'
        ]
        response 200 do
          schema type: :array do
            items do
              key :'$ref', :User
            end
          end
        end
      end
      operation :post do
        security do
          key :Authorization, []
        end
        key :tags, ['user']
        key :description, 'Creates a new user'
        key :operationId, 'addUser'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :user
          key :in, :body
          key :description, 'User to create'
          key :required, true
          schema do
            key :'$ref', :UserInput
          end
        end
        response 200 do
          schema do
            key :'$ref', :User
          end
        end
        response 422 do
          key :description, 'Unprocessable Entity'
          schema do
            key :'$ref', :SwaggerError
          end
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
        key :tags, ['user']
        key :description, 'Update an user'
        key :operationId, 'updateUser'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :user
          key :in, :body
          key :description, 'User to update'
          key :required, true
          schema do
            key :'$ref', :UserInput
          end
        end
        response 200 do
          schema do
            key :'$ref', :User
          end
        end
        response 422 do
          key :description, 'Unprocessable Entity'
          schema do
            key :'$ref', :SwaggerError
          end
        end
      end
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, ['user']
        key :description, 'Returns an user'
        key :operationId, 'findUserById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          schema do
            key :'$ref', :User
          end
        end
      end
      operation :delete do
        security do
          key :Authorization, []
        end
        key :tags, ['user']
        key :description, 'Deletes a single user'
        key :operationId, 'deleteUser'
        response 204
      end
    end
  end
end
