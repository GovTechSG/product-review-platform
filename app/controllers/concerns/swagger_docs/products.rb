module SwaggerDocs::Products
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/companies/{company_id}/products' do
      parameter do
        key :name, :company_id
        key :in, :path
        key :description, 'ID of company'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :get do
        key :tags, ['product']
        key :description, 'Returns list of all products from specified company'
        key :operationId, 'findProductsByCompany'
        key :produces, [
          'application/json'
        ]
        response 200 do
          schema type: :array do
            items do
              key :'$ref', :Product
            end
          end
        end
      end
      operation :post do
        key :tags, ['product']
        key :description, 'Creates a new product belonging to specified company'
        key :operationId, 'addProductByCompany'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :product
          key :in, :body
          key :description, 'Product to create'
          key :required, true
          schema do
            key :'$ref', :ProductInput
          end
        end
        response 200 do
          schema do
            key :'$ref', :Product
          end
        end
        response 422 do
          key :description, 'Unprocessable Entity'
          schema do
            key :'$ref', :SwaggerErrorModel
          end
        end
      end
    end

    swagger_path '/products/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of product'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :put do
        key :tags, ['product']
        key :description, 'Update a product'
        key :operationId, 'updateProduct'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :product
          key :in, :body
          key :description, 'Product to update'
          key :required, true
          schema do
            key :'$ref', :ProductInput
          end
        end
        response 200 do
          schema do
            key :'$ref', :Product
          end
        end
        response 422 do
          key :description, 'Unprocessable Entity'
          schema do
            key :'$ref', :SwaggerErrorModel
          end
        end
      end
      operation :get do
        key :tags, ['product']
        key :description, 'Returns a product'
        key :operationId, 'findProductById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          schema do
            key :'$ref', :Product
          end
        end
      end
      operation :delete do
        key :tags, ['product']
        key :description, 'Deletes a single product'
        key :operationId, 'deleteProduct'
        response 204
      end
    end
  end
end