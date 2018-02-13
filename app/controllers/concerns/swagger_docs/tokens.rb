module SwaggerDocs::Tokens
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/oauth/token' do
      operation :post do
        key :tags, ['Authorisation']
        key :description, 'Sign in, to access the API'
        key :operationId, 'signIn'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :token
          key :in, :body
          key :description, 'Sign In'
          key :required, true
          schema do
            key :'$ref', :TokenInput
          end
        end
        response 200 do
          schema do
            key :'$ref', :Token
          end
        end
      end
    end

    swagger_path '/oauth/refresh' do
      operation :post do
        key :tags, ['Authorisation']
        key :description, 'Refresh, to get another access code'
        key :operationId, 'refresh'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :token
          key :in, :body
          key :description, 'Refresh'
          key :required, true
          schema do
            key :'$ref', :TokenInput
          end
        end
        response 200 do
          schema do
            key :'$ref', :Token
          end
        end
      end
    end

    swagger_path '/oauth/revoke' do
      operation :post do
        key :tags, ['Authorisation']
        key :description, 'Revoke, to sign out the user access'
        key :operationId, 'revoke'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :token
          key :in, :body
          key :description, 'Revoke'
          key :required, true
          schema do
            key :'$ref', :TokenSignoutInput
          end
        end
        response 200 do
          schema do
            key :'$ref', :Token
          end
        end
      end
    end
  end
end
