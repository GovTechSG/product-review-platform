module SwaggerDocs::Companies
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/companies' do
      operation :get do
        key :tags, ['company']
        key :description, 'Returns list of all companies'
        key :operationId, 'findCompanies'
        key :produces, [
          'application/json'
        ]
        response 200 do
          schema type: :array do
            items do
              key :'$ref', :Company
            end
          end
        end
      end
      operation :post do
        key :tags, ['company']
        key :description, 'Creates a new company'
        key :operationId, 'addCompany'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :company
          key :in, :body
          key :description, 'Company to create'
          key :required, true
          schema do
            key :'$ref', :CompanyInput
          end
        end
        response 200 do
          schema do
            key :'$ref', :Company
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

    swagger_path '/companies/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of company'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :put do
        key :tags, ['company']
        key :description, 'Update a company'
        key :operationId, 'updateCompany'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :company
          key :in, :body
          key :description, 'Company to update'
          key :required, true
          schema do
            key :'$ref', :CompanyInput
          end
        end
        response 200 do
          schema do
            key :'$ref', :Company
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
        key :tags, ['company']
        key :description, 'Returns a company'
        key :operationId, 'findCompanyById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          schema do
            key :'$ref', :Company
          end
        end
      end
      operation :delete do
        key :tags, ['company']
        key :description, 'Deletes a single company'
        key :operationId, 'deleteCompany'
        response 204
      end
    end
  end
end