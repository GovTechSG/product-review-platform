module SwaggerDocs::Tokens
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/oauth/token' do
      operation :post do
        key :tags, ['Authorisation']
        key :description, 'Sign in, to get your access token for the APIs'
        key :operationId, 'signIn'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'Sign In with valid Username and Password, access token will be shown from the response'
          key :required, true
          schema do
            key :'$ref', :TokenInput
          end
        end
        response 200 do
          key :description, 'OK, Sign In is successful.'
          schema do
            key :'$ref', :Token
          end
        end
        response 401 do
          key :description, 'Unauthorised. Missing or invalid credentials'
        end
      end
    end

    swagger_path '/api/v1/oauth/refresh' do
      operation :post do
        key :tags, ['Authorisation']
        key :description, 'Refresh, to get another access code'
        key :operationId, 'refresh'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'Refresh with valid Username, Password and Access token,
new access token will be shown from the response'
          key :required, true
          schema do
            key :'$ref', :TokenRefreshInput
          end
        end
        response 200 do
          key :description, 'OK, Refresh of access token is successful.'
          schema do
            key :'$ref', :Token
          end
        end
        response 401 do
          key :description, 'Unauthorised. Missing or invalid credentials'
        end
      end
    end

    swagger_path '/api/v1/oauth/revoke' do
      operation :post do
        key :tags, ['Authorisation']
        key :description, 'Revoke, to sign out the user access from the API'
        key :operationId, 'revoke'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'Sign Out with valid access token, access token will no longer be valid'
          key :required, true
          schema do
            key :'$ref', :TokenSignoutInput
          end
        end
        response 200 do
          key :description, 'OK, Sign Out is successful.'
          schema do
            key :example, "{}"
          end
        end
        response 404 do
          key :description, 'Not found. Access token given is invalid/not found.'
        end
      end
    end
  end
end
