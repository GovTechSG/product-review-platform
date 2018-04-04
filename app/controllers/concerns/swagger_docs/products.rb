module SwaggerDocs::Products
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/companies/{company_id}/products' do
      parameter do
        key :name, :company_id
        key :in, :path
        key :description, [I18n.t('swagger_ui.path_id_description', model: "Company").to_s]
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, [I18n.t('product.key').to_s]
        key :description, [I18n.t('swagger_ui.index_with_FK_description', model: "Products", id: "Company").to_s]
        key :operationId, 'findProductsByCompany'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, [I18n.t('swagger_ui.index_success_description', model: "Products").to_s]
          schema type: :array do
            items do
              key :'$ref', :Product
            end
          end
        end
        response 401 do
          key :'$ref', :UnauthorisedError
        end
        response 404 do
          key :'$ref', :NotFoundError
        end
      end
      operation :post do
        security do
          key :Authorization, []
        end
        key :tags, [I18n.t('product.key').to_s]
        key :description, [I18n.t('swagger_ui.create_description', model: "Product").to_s]
        key :operationId, 'addProductByCompany'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, [I18n.t('swagger_ui.create_param_description', model: "Product").to_s]
          key :required, true
          schema do
            key :'$ref', :ProductInput
          end
        end
        response 201 do
          key :description, [I18n.t('swagger_ui.create_success_description', model: "Product").to_s]
          schema do
            key :'$ref', :Product
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
    end

    swagger_path '/api/v1/products/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, [I18n.t('swagger_ui.path_id_description', model: "Product").to_s]
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :put do
        security do
          key :Authorization, []
        end
        key :tags, [I18n.t('product.key').to_s]
        key :description, [I18n.t('swagger_ui.update_description', model: "Product").to_s]
        key :operationId, 'updateProduct'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, [I18n.t('swagger_ui.update_param_description', model: "Product").to_s]
          key :required, true
          schema do
            key :'$ref', :ProductInput
          end
        end
        response 200 do
          key :description, [I18n.t('swagger_ui.update_success_description', model: "Product").to_s]
          schema do
            key :'$ref', :Product
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
        key :tags, [I18n.t('product.key').to_s]
        key :description, [I18n.t('swagger_ui.get_description', model: "Product").to_s]
        key :operationId, 'findProductById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, [I18n.t('swagger_ui.get_success_description', model: "Product").to_s]
          schema do
            key :'$ref', :Product
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
        key :tags, [I18n.t('product.key').to_s]
        key :description, [I18n.t('swagger_ui.delete_description', model: "Product").to_s]
        key :operationId, 'deleteProduct'
        response 204 do
          key :description, [I18n.t('swagger_ui.delete_success_description', model: "Product").to_s]
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
