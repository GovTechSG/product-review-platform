module SwaggerDocs::Likes
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/reviews/{review_id}/likes' do
      parameter do
        key :name, :review_id
        key :in, :path
        key :description, 'ID of review'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, ['Like']
        key :description, 'Returns list of all likes from specified review'
        key :operationId, 'findLikesByReview'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, list of likes fetched'
          schema type: :array do
            items do
              key :'$ref', :Like
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
        key :tags, ['Like']
        key :description, 'Creates a new like that belong to a specified review'
        key :operationId, 'addLikeByReview'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'Details of Like to be created'
          key :required, true
          schema do
            key :'$ref', :LikeInput
          end
        end
        response 201 do
          key :description, 'OK, like is successfully created'
          schema do
            key :'$ref', :Like
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

    swagger_path '/api/v1/likes/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of like'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, ['Like']
        key :description, 'Returns a like'
        key :operationId, 'findLikeById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, like of the given ID fetched'
          schema do
            key :'$ref', :Like
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
        key :tags, ['Like']
        key :description, 'Deletes a single like'
        key :operationId, 'deleteLike'
        response 204 do
          key :description, 'No content success. Like of the given ID is deleted'
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
