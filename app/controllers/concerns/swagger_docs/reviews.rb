module SwaggerDocs::Reviews
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/products/{product_id}/reviews' do
      parameter do
        key :name, :product_id
        key :in, :path
        key :description, 'ID of product'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, ['review']
        key :description, 'Returns list of all reviews from specified product'
        key :operationId, 'findProductsByReview'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, Reviews of the given product ID fetched'
          schema type: :array do
            items do
              key :'$ref', :Review
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
        key :tags, ['review']
        key :description, 'Creates a new review that belong to a specified product'
        key :operationId, 'addReviewByProduct'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'Details of the review to be created'
          key :required, true
          schema do
            key :'$ref', :ProductReviewInput
          end
        end
        response 201 do
          key :description, 'OK, review is successfully created'
          schema do
            key :'$ref', :Review
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
      end
    end

    swagger_path '/api/v1/services/{service_id}/reviews' do
      parameter do
        key :name, :service_id
        key :in, :path
        key :description, 'ID of service'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, ['review']
        key :description, 'Returns list of all reviews from specified service'
        key :operationId, 'findReviewsByService'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, Reviews of the given service ID fetched'
          schema type: :array do
            items do
              key :'$ref', :Review
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
        key :tags, ['review']
        key :description, 'Creates a new review belonging to specified service'
        key :operationId, 'addReviewByService'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :review
          key :in, :body
          key :description, 'Review to create'
          key :required, true
          schema do
            key :'$ref', :ServiceReviewInput
          end
        end
        response 200 do
          schema do
            key :'$ref', :Review
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

    swagger_path '/api/v1/reviews/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of review'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :put do
        security do
          key :Authorization, []
        end
        key :tags, ['review']
        key :description, 'Update a review'
        key :operationId, 'updateReview'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :review
          key :in, :body
          key :description, 'Review to update'
          key :required, true
          schema do
            key :'$ref', :ReviewInput
          end
        end
        response 200 do
          schema do
            key :'$ref', :Review
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
        key :tags, ['review']
        key :description, 'Returns a review'
        key :operationId, 'findReviewById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, Review of the given ID fetched'
          schema do
            key :'$ref', :Review
          end
        end
        response 401 do
          key :'$ref', :UnauthorisedError
        end
      end
      operation :delete do
        security do
          key :Authorization, []
        end
        key :tags, ['review']
        key :description, 'Deletes a single review'
        key :operationId, 'deleteReview'
        response 204
      end
    end
  end
end
