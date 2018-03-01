module SwaggerDocs::Products
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/companies/{company_id}/products' do
      parameter do
        key :name, :company_id
        key :in, :path
        key :description, 'ID of company'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, ['Product']
        key :description, 'Returns list of all products from specified company'
        key :operationId, 'findProductsByCompany'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, list of products fetched from given company ID'
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
        key :tags, ['Product']
        key :description, 'Creates a new product belonging to specified company'
        key :operationId, 'addProductByCompany'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'Details of the product to be created'
          key :required, true
          schema do
            key :'$ref', :ProductInput
          end
        end
        response 201 do
          key :description, 'OK, company is successfully created'
          schema do
            key :'$ref', :Product
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
    end

    swagger_path '/api/v1/products/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of product'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :put do
        security do
          key :Authorization, []
        end
        key :tags, ['Product']
        key :description, 'Update a product'
        key :operationId, 'updateProduct'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'New details of product to be updated'
          key :required, true
          schema do
            key :'$ref', :ProductInput
          end
        end
        response 200 do
          key :description, 'OK, company is successfully updated'
          schema do
            key :'$ref', :Product
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
        key :tags, ['Product']
        key :description, 'Returns a product'
        key :operationId, 'findProductById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, product fetched from the given product ID'
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
        key :tags, ['Product']
        key :description, 'Deletes a single product'
        key :operationId, 'deleteProduct'
        response 204 do
          key :description, 'No content success. Product of the given ID is deleted'
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
