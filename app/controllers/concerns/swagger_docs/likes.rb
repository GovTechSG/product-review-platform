module SwaggerDocs::Likes
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/reviews/{review_id}/likes' do
      parameter do
        key :name, :review_id
        key :in, :path
        key :description, 'ID of review'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :get do
        key :tags, ['like']
        key :description, 'Returns list of all likes from specified review'
        key :operationId, 'findLikesByReview'
        key :produces, [
            'application/json'
        ]
        response 200 do
          schema type: :array do
            items do
              key :'$ref', :Like
            end
          end
        end
      end
      operation :post do
        key :tags, ['like']
        key :description, 'Creates a new like belonging to specified review'
        key :operationId, 'addLikeByReview'
        key :produces, [
            'application/json'
        ]
        parameter do
          key :name, :like
          key :in, :body
          key :description, 'Like to create'
          key :required, true
          schema do
            key :'$ref', :LikeInput
          end
        end
        response 200 do
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
      end
    end

    swagger_path '/likes/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of like'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :get do
        key :tags, ['like']
        key :description, 'Returns a like'
        key :operationId, 'findLikeById'
        key :produces, [
            'application/json'
        ]
        response 200 do
          schema do
            key :'$ref', :Like
          end
        end
      end
      operation :delete do
        key :tags, ['like']
        key :description, 'Deletes a single like'
        key :operationId, 'deleteLike'
        response 204
      end
    end
  end
end
