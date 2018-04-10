module SwaggerDocs::Companies
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/companies' do
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, [I18n.t('company.key').to_s]
        key :description, I18n.t('swagger_ui.index_description', model: 'Companies').to_s
        key :operationId, 'findCompanies'
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
          key :description, I18n.t('swagger_ui.index_success_description', model: 'Companies').to_s
          schema type: :array do
            items do
              key :'$ref', :Company
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
        key :tags, [I18n.t('company.key').to_s]
        key :description, I18n.t('swagger_ui.create_description', model: 'Company').to_s
        key :operationId, 'addCompany'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, I18n.t('swagger_ui.create_param_description', model: 'Company').to_s
          key :required, true
          schema do
            key :'$ref', :CompanyInput
          end
        end
        response 201 do
          key :description, I18n.t('swagger_ui.create_success_description', model: 'Company').to_s
          schema do
            key :'$ref', :Company
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

    swagger_path '/api/v1/companies/{company_id}/clients' do
      parameter do
        key :name, :company_id
        key :in, :path
        key :description, I18n.t('swagger_ui.path_id_description', model: 'Company').to_s
        key :required, true
        key :type, :string
      end
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, [I18n.t('company.key').to_s]
        key :description, I18n.t('swagger_ui.index_description', model: 'Clients').to_s
        key :operationId, 'findCompaniesClients'
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
          key :description, I18n.t('swagger_ui.index_success_description', model: 'Clients').to_s
          schema type: :array do
            items do
              key :'$ref', :Company
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
    end

    swagger_path '/api/v1/companies/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, I18n.t('swagger_ui.path_id_description', model: 'Company').to_s
        key :required, true
        key :type, :string
      end
      operation :put do
        security do
          key :Authorization, []
        end
        key :tags, [I18n.t('company.key').to_s]
        key :description, I18n.t('swagger_ui.update_description', model: 'Company').to_s
        key :operationId, 'updateCompany'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, I18n.t('swagger_ui.update_param_description', model: 'Company').to_s
          key :required, true
          schema do
            key :'$ref', :CompanyInput
          end
        end
        response 200 do
          key :description, I18n.t('swagger_ui.create_success_description', model: 'Company').to_s
          schema do
            key :'$ref', :Company
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
        key :tags, [I18n.t('company.key').to_s]
        key :description, I18n.t('swagger_ui.index_description', model: 'Company').to_s
        key :operationId, 'findCompanyById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, I18n.t('swagger_ui.index_success_description', model: 'Company').to_s
          schema do
            key :'$ref', :Company
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
        key :tags, [I18n.t('company.key').to_s]
        key :description, I18n.t('swagger_ui.delete_description', model: 'Company').to_s
        key :operationId, 'deleteCompany'
        response 204 do
          key :description, I18n.t('swagger_ui.delete_success_description', model: 'Company').to_s
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
