module SwaggerDocs::Comments
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/reviews/{review_id}/comments' do
      parameter do
        key :name, :review_id
        key :in, :path
        key :description, I18n.t('swagger_ui.path_id_description', model: 'Review').to_s
        key :required, true
        key :type, :string
      end
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, [I18n.t('comment.key').to_s]
        key :description, I18n.t('swagger_ui.index_with_FK_description', model: 'Comments', id: 'Review').to_s
        key :operationId, 'findCommentsByReview'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :page
          key :in, :query
          key :description, 'Page Number to display'
          key :type, :integer
          key :format, :int64
        end
        parameter do
          key :name, :per_page
          key :in, :query
          key :description, 'Number of items to display per page'
          key :type, :integer
          key :format, :int64
        end
        response 200 do
          key :description, I18n.t('swagger_ui.index_success_description', model: 'Comments').to_s
          schema type: :array do
            items do
              key :'$ref', :Comment
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
        key :tags, [I18n.t('comment.key').to_s]
        key :description, I18n.t('swagger_ui.create_with_FK_description', model: 'Comment', id: 'Review').to_s
        key :operationId, 'addCommentByReview'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, I18n.t('swagger_ui.create_param_description', model: 'Comment').to_s
          key :required, true
          schema do
            key :'$ref', :CommentCreateInput
          end
        end
        response 201 do
          key :description, I18n.t('swagger_ui.create_success_description', model: 'Comment').to_s
          schema do
            key :'$ref', :Comment
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

    swagger_path '/api/v1/comments/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, I18n.t('swagger_ui.path_id_description', model: 'Comment').to_s
        key :required, true
        key :type, :string
      end
      operation :put do
        security do
          key :Authorization, []
        end
        key :tags, [I18n.t('comment.key').to_s]
        key :description, I18n.t('swagger_ui.update_description', model: 'Comment').to_s
        key :operationId, 'updateComment'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, I18n.t('swagger_ui.update_param_description', model: 'Comment').to_s
          key :required, true
          schema do
            key :'$ref', :CommentUpdateInput
          end
        end
        response 200 do
          key :description, I18n.t('swagger_ui.update_success_description', model: 'Comment').to_s
          schema do
            key :'$ref', :Comment
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
        key :tags, [I18n.t('comment.key').to_s]
        key :description, I18n.t('swagger_ui.get_description', model: 'Comment').to_s
        key :operationId, 'findCommentById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, I18n.t('swagger_ui.get_success_description', model: 'Comment').to_s
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
        key :tags, [I18n.t('comment.key').to_s]
        key :description, I18n.t('swagger_ui.delete_description', model: 'Comment').to_s
        key :operationId, 'deleteComment'
        response 204 do
          key :description, I18n.t('swagger_ui.delete_success_description', model: 'Comment').to_s
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
