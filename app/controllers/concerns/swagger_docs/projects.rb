module SwaggerDocs::Projects
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/companies/{company_id}/projects' do
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
        key :tags, [I18n.t('project.key').to_s]
        key :description, I18n.t('swagger_ui.index_with_FK_description', model: "Projects", id: "Company").to_s
        key :operationId, 'findProjectsByCompany'
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
          key :description, I18n.t('swagger_ui.index_success_description', model: "Projects").to_s
          schema type: :array do
            items do
              key :'$ref', :Project
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
        key :tags, [I18n.t('project.key').to_s]
        key :description, I18n.t('swagger_ui.create_description', model: "Project").to_s
        key :operationId, 'addProjectByCompany'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, I18n.t('swagger_ui.create_param_description', model: "Project").to_s
          key :required, true
          schema do
            key :'$ref', :ProjectInput
          end
        end
        response 201 do
          key :description, I18n.t('swagger_ui.create_success_description', model: "Project").to_s
          schema do
            key :'$ref', :Project
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

    swagger_path '/api/v1/project/project_name' do
      parameter do
        key :name, :project_name
        key :in, :path
        key :description, I18n.t('swagger_ui.path_name_description', model: 'Project').to_s
        key :required, true
        key :type, :string
      end
      operation :post do
        security do
          key :Authorization, []
        end
        key :tags, [I18n.t('project.key').to_s]
        key :description, I18n.t('swagger_ui.get_description', model: 'Project').to_s
        key :operationId, 'findProject'
        key :produces, [
            'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, I18n.t('swagger_ui.update_param_description', model: "Project").to_s
          key :required, true
          schema do
            key :'$ref', :CompanyInput
          end
        end
        response 200 do
          key :description, I18n.t('swagger_ui.get_success_description', model: 'Project').to_s
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

    swagger_path '/api/v1/projects/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, I18n.t('swagger_ui.path_id_description', model: "Project").to_s
        key :required, true
        key :type, :string
      end
      operation :put do
        security do
          key :Authorization, []
        end
        key :tags, [I18n.t('project.key').to_s]
        key :description, I18n.t('swagger_ui.update_description', model: "Project").to_s
        key :operationId, 'updateProject'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, I18n.t('swagger_ui.update_param_description', model: "Project").to_s
          key :required, true
          schema do
            key :'$ref', :ProjectInput
          end
        end
        response 200 do
          key :description, I18n.t('swagger_ui.update_success_description', model: "Project").to_s
          schema do
            key :'$ref', :Project
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
        key :tags, [I18n.t('project.key').to_s]
        key :description, I18n.t('swagger_ui.get_description', model: "Project").to_s
        key :operationId, 'findProjectById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, I18n.t('swagger_ui.get_success_description', model: "Project").to_s
          schema do
            key :'$ref', :Project
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
        key :tags, [I18n.t('project.key').to_s]
        key :description, I18n.t('swagger_ui.delete_description', model: "Project").to_s
        key :operationId, 'deleteProject'
        response 204 do
          key :description, I18n.t('swagger_ui.delete_success_description', model: "Project").to_s
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
