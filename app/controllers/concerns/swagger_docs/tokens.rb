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

  end
end
