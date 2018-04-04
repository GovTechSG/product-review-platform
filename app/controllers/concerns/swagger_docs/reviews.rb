module SwaggerDocs::Reviews
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/products/{product_id}/reviews' do
      parameter do
        key :name, :product_id
        key :in, :path
        key :description, I18n.t('swagger_ui.path_id_description', model: "Product").to_s
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, [I18n.t('review.key').to_s]
        key :description, I18n.t('swagger_ui.index_with_FK_description', model: "Reviews", id: "Product").to_s
        key :operationId, 'findProductsByReview'
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
        response 200 do
          key :description, I18n.t('swagger_ui.index_success_description', model: "Reviews").to_s
          schema type: :array do
            items do
              key :'$ref', :Review
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
        key :tags, [I18n.t('review.key').to_s]
        key :description, I18n.t('swagger_ui.create_with_FK_description', model: "Review", id: "Product").to_s
        key :operationId, 'addReviewByProduct'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, I18n.t('swagger_ui.create_param_description', model: "Review").to_s
          key :required, true
          schema do
            key :'$ref', :ProductReviewInput
          end
        end
        response 201 do
          key :description, I18n.t('swagger_ui.create_success_description', model: "Review").to_s
          schema do
            key :'$ref', :Review
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

    swagger_path '/api/v1/services/{service_id}/reviews' do
      parameter do
        key :name, :service_id
        key :in, :path
        key :description, I18n.t('swagger_ui.path_id_description', model: "Service").to_s
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, [I18n.t('review.key').to_s]
        key :description, I18n.t('swagger_ui.index_with_FK_description', model: "Review", id: "Service").to_s
        key :operationId, 'findReviewsByService'
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
        response 200 do
          key :description, I18n.t('swagger_ui.index_success_description', model: "Review").to_s
          schema type: :array do
            items do
              key :'$ref', :Review_Service
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
        key :tags, [I18n.t('review.key').to_s]
        key :description, I18n.t('swagger_ui.create_with_FK_description', model: "Review", id: "Service").to_s
        key :operationId, 'addReviewByService'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, I18n.t('swagger_ui.create_param_description', model: "Review").to_s
          key :required, true
          schema do
            key :'$ref', :ServiceReviewInput
          end
        end
        response 201 do
          key :description, I18n.t('swagger_ui.create_success_description', model: "Review").to_s
          schema do
            key :'$ref', :Review_Service
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

    swagger_path '/api/v1/reviews/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, I18n.t('swagger_ui.path_id_description', model: "Review").to_s
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :put do
        security do
          key :Authorization, []
        end
        key :tags, [I18n.t('review.key').to_s]
        key :description, I18n.t('swagger_ui.update_description', model: "Review").to_s
        key :operationId, 'updateReview'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, I18n.t('swagger_ui.update_param_description', model: "Review").to_s
          key :required, true
          schema do
            key :'$ref', :ReviewInput
          end
        end
        response 200 do
          key :description, I18n.t('swagger_ui.update_success_description', model: "Review").to_s
          schema do
            key :'$ref', :Review
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
        key :tags, [I18n.t('review.key').to_s]
        key :description, I18n.t('swagger_ui.get_description', model: "Review").to_s
        key :operationId, 'findReviewById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, I18n.t('swagger_ui.get_success_description', model: "Review").to_s
          schema do
            key :'$ref', :Review
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
        key :tags, [I18n.t('review.key').to_s]
        key :description, I18n.t('swagger_ui.delete_description', model: "Review").to_s
        key :operationId, 'deleteReview'
        response 204 do
          key :description, I18n.t('swagger_ui.delete_success_description', model: "Review").to_s
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
