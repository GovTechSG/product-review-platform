module SwaggerDocs::Aspects
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/aspects' do
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, [I18n.t('aspect.key').to_s]
        key :description, I18n.t('swagger_ui.index_description', model: "Aspects").to_s
        key :operationId, 'findAspects'
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
          key :description, I18n.t('swagger_ui.index_success_description', model: "Aspects").to_s
          schema type: :array do
            items do
              key :'$ref', :Aspect
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
        key :tags, [I18n.t('aspect.key').to_s]
        key :description, I18n.t('swagger_ui.create_description', model: "Aspect").to_s
        key :operationId, 'addAspect'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, I18n.t('swagger_ui.create_param_description', model: "Aspect").to_s
          key :required, true
          schema do
            key :'$ref', :AspectInput
          end
        end
        response 201 do
          key :description, I18n.t('swagger_ui.create_success_description', model: "Aspect").to_s
          schema do
            key :'$ref', :Aspect
          end
        end
        response 422 do
          key :'$ref', :SwaggerError
        end
        response 401 do
          key :'$ref', :UnauthorisedError
        end
        response 400 do
          key :'$ref', :BadRequestError
        end
      end
    end

    swagger_path '/api/v1/companies/{companies_id}/aspects' do
      parameter do
        key :name, :company_id
        key :in, :path
        key :description, I18n.t('swagger_ui.path_id_description', model: "Company").to_s
        key :required, true
        key :type, :string
      end
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, [I18n.t('review.key').to_s]
        key :description, I18n.t('swagger_ui.index_with_FK_description', model: "Aspect", id: "Company").to_s
        key :operationId, 'findAspectsByCompany'
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
        parameter do
          key :name, :filter_by_score
          key :in, :query
          key :description, 'POSITIVE/NEUTRAL/NEGATIVE'
          key :type, :string
        end
        parameter do
          key :name, :sort_by
          key :in, :query
          key :description, 'created_at'
          key :type, :string
        end
        parameter do
          key :name, :count
          key :in, :query
          key :description, 'true'
          key :type, :string
        end
        response 200 do
          key :description, I18n.t('swagger_ui.index_success_description', model: "Aspect").to_s
          key :'$ref', :Aspect_Company
        end
        response 401 do
          key :'$ref', :UnauthorisedError
        end
        response 404 do
          key :'$ref', :NotFoundError
        end
      end
    end

    swagger_path '/api/v1/aspects/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, I18n.t('swagger_ui.path_id_description', model: "Aspect").to_s
        key :required, true
        key :type, :string
      end
      operation :put do
        security do
          key :Authorization, []
        end
        key :tags, [I18n.t('aspect.key').to_s]
        key :description, I18n.t('swagger_ui.update_description', model: "Aspect").to_s
        key :operationId, 'updateAspect'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, I18n.t('swagger_ui.update_param_description', model: "Aspect").to_s
          key :required, true
          schema do
            key :'$ref', :AspectInput
          end
        end
        response 200 do
          key :description, I18n.t('swagger_ui.update_success_description', model: "Aspect").to_s
          schema do
            key :'$ref', :Aspect
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
        key :tags, [I18n.t('aspect.key').to_s]
        key :description, I18n.t('swagger_ui.get_description', model: "Aspect").to_s
        key :operationId, 'findAspectById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, I18n.t('swagger_ui.get_success_description', model: "Aspect").to_s
          schema do
            key :'$ref', :Aspect
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
        key :tags, [I18n.t('aspect.key').to_s]
        key :description, I18n.t('swagger_ui.delete_description', model: "Aspect").to_s
        key :operationId, 'deleteAspect'
        response 204 do
          key :description, I18n.t('swagger_ui.delete_success_description', model: "Aspect").to_s
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
