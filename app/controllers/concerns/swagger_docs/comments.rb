module SwaggerDocs::Comments
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/reviews/{review_id}/comments' do
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
        key :tags, ['comment']
        key :description, 'Returns list of all comments from specified review'
        key :operationId, 'findCommentsByReview'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, comments of the given ID fetched'
          schema type: :array do
            items do
              key :'$ref', :Comment
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
        key :tags, ['comment']
        key :description, 'Creates a new comment that belong to a specified review'
        key :operationId, 'addCommentByReview'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'Details of Comment to be created'
          key :required, true
          schema do
            key :'$ref', :CommentCreateInput
          end
        end
        response 201 do
          key :description, 'OK, Comment is successfully created'
          schema do
            key :'$ref', :Comment
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

    swagger_path '/api/v1/comments/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of comment'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :put do
        security do
          key :Authorization, []
        end
        key :tags, ['comment']
        key :description, 'Update a comment'
        key :operationId, 'updateComment'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'New details of the Comment to be updated'
          key :required, true
          schema do
            key :'$ref', :CommentUpdateInput
          end
        end
        response 200 do
          key :description, 'OK, comment is successfully updated'
          schema do
            key :'$ref', :Comment
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
      end
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, ['comment']
        key :description, 'Returns a comment'
        key :operationId, 'findCommentById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, comment of the given ID fetched'
          schema do
            key :'$ref', :Comment
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
        key :tags, ['comment']
        key :description, 'Deletes a single comment'
        key :operationId, 'deleteComment'
        response 204 do
          key :description, 'No content success. Comment of the given ID is deleted'
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
