module SwaggerDocs::Likes
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/reviews/{review_id}/likes' do
      parameter do
        key :name, :review_id
        key :in, :path
        key :description, I18n.t('swagger_ui.path_id_description', model: "Review").to_s
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, [I18n.t('like.key').to_s]
        key :description, I18n.t('swagger_ui.index_with_FK_description', model: "Likes", id: "Review").to_s
        key :operationId, 'findLikesByReview'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, I18n.t('swagger_ui.index_success_description', model: "Likes").to_s
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
        key :tags, [I18n.t('like.key').to_s]
        key :description, I18n.t('swagger_ui.create_with_FK_description', model: "Like", id: "Review").to_s
        key :operationId, 'addLikeByReview'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, I18n.t('swagger_ui.create_param_description', model: "Like").to_s
          key :required, true
          schema do
            key :'$ref', :LikeInput
          end
        end
        response 201 do
          key :description, I18n.t('swagger_ui.create_success_description', model: "Like").to_s
          schema do
            key :'$ref', :Like
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

    swagger_path '/api/v1/likes/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, I18n.t('swagger_ui.path_id_description', model: "Like").to_s
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, [I18n.t('like.key').to_s]
        key :description, I18n.t('swagger_ui.get_description', model: "Like").to_s
        key :operationId, 'findLikeById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, I18n.t('swagger_ui.get_success_description', model: "Like").to_s
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
        key :tags, [I18n.t('like.key').to_s]
        key :description, I18n.t('swagger_ui.delete_description', model: "Like").to_s
        key :operationId, 'deleteLike'
        response 204 do
          key :description, I18n.t('swagger_ui.delete_success_description', model: "Like").to_s
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
