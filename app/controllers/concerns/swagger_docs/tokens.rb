module SwaggerDocs::Tokens
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/oauth/token' do
      operation :post do
        key :tags, [I18n.t('token.authorisation_key').to_s]
        key :description, I18n.t('swagger_ui.sign_in_description').to_s
        key :operationId, 'signIn'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, I18n.t('swagger_ui.sign_in_param_description').to_s
          key :required, true
          schema do
            key :'$ref', :TokenInput
          end
        end
        response 200 do
          key :description, I18n.t('swagger_ui.sign_in_success_description').to_s
          schema do
            key :'$ref', :Token
          end
        end
        response 401 do
          key :description, I18n.t('swagger_ui.authorisation_fail_description').to_s
        end
      end
    end

    swagger_path '/api/v1/oauth/refresh' do
      operation :post do
        key :tags, [I18n.t('token.authorisation_key').to_s]
        key :description, I18n.t('swagger_ui.refresh_description').to_s
        key :operationId, 'refresh'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, I18n.t('swagger_ui.refresh_param_description').to_s
          key :required, true
          schema do
            key :'$ref', :TokenRefreshInput
          end
        end
        response 200 do
          key :description, I18n.t('swagger_ui.refresh_success_description').to_s
          schema do
            key :'$ref', :Token
          end
        end
        response 401 do
          key :description, I18n.t('swagger_ui.authorisation_fail_description').to_s
        end
      end
    end

    swagger_path '/api/v1/oauth/revoke' do
      operation :post do
        key :tags, [I18n.t('token.authorisation_key').to_s]
        key :description, I18n.t('swagger_ui.sign_out_description').to_s
        key :operationId, 'revoke'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, I18n.t('swagger_ui.sign_out_param_description').to_s
          key :required, true
          schema do
            key :'$ref', :TokenSignoutInput
          end
        end
        response 200 do
          key :description, I18n.t('swagger_ui.sign_out_success_description').to_s
          schema do
            key :example, {}
          end
        end
        response 404 do
          key :description, I18n.t('swagger_ui.sign_out_token_not_found').to_s
        end
      end
    end
  end
end
