module SwaggerDocs::Comments
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/reviews/{review_id}/comments' do
      operation :get do
        key :tags, ['comment']
        key :description, 'Returns list of all comments from specified review'
        key :operationId, 'findCommentsByReview'
        key :produces, [
          'application/json'
        ]
        response 200 do
          schema type: :array do
            items do
              key :'$ref', :Comment
            end
          end
        end
      end
      operation :post do
        key :tags, ['comment']
        key :description, 'Creates a new comment belonging to specified review'
        key :operationId, 'addCommentByReview'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :comment
          key :in, :body
          key :description, 'Comment to create'
          key :required, true
          schema do
            key :'$ref', :CommentCreateInput
          end
        end
        response 200 do
          schema do
            key :'$ref', :Comment
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

    swagger_path '/comments/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of comment'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :put do
        key :tags, ['comment']
        key :description, 'Update a comment'
        key :operationId, 'updateComment'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :comment
          key :in, :body
          key :description, 'Comment to update'
          key :required, true
          schema do
            key :'$ref', :CommentUpdateInput
          end
        end
        response 200 do
          schema do
            key :'$ref', :Comment
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
        key :tags, ['comment']
        key :description, 'Returns a comment'
        key :operationId, 'findCommentById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          schema do
            key :'$ref', :Comment
          end
        end
      end
      operation :delete do
        key :tags, ['comment']
        key :description, 'Deletes a single comment'
        key :operationId, 'deleteComment'
        response 204
      end
    end
  end
end