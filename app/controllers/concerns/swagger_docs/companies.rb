module SwaggerDocs::Companies
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/companies' do
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, ['Company']
        key :description, 'Returns list of all companies'
        key :operationId, 'findCompanies'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, list of companies fetched'
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
        key :tags, ['Company']
        key :description, 'Creates a new company'
        key :operationId, 'addCompany'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'Details of the company to be created'
          key :required, true
          schema do
            key :'$ref', :CompanyInput
          end
        end
        response 201 do
          key :description, 'OK, company is successfully created'
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

    swagger_path '/api/v1/companies/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of company'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :put do
        security do
          key :Authorization, []
        end
        key :tags, ['Company']
        key :description, 'Update a company'
        key :operationId, 'updateCompany'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'New details of the company to be updated'
          key :required, true
          schema do
            key :'$ref', :CompanyInput
          end
        end
        response 200 do
          key :description, 'OK, company is successfully updated'
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
        key :tags, ['Company']
        key :description, 'Returns a company'
        key :operationId, 'findCompanyById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, company of the given ID fetched'
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
        key :tags, ['Company']
        key :description, 'Deletes a single company'
        key :operationId, 'deleteCompany'
        response 204 do
          key :description, 'No content success. Company of the given ID is deleted'
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
