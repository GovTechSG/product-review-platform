module SwaggerDocs::Services
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/companies/{company_id}/services' do
      parameter do
        key :name, :company_id
        key :in, :path
        key :description, 'ID of company'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, ['service']
        key :description, 'Returns list of all services from specified company'
        key :operationId, 'findServicesByCompany'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, Services of the given company ID fetched'
          schema type: :array do
            items do
              key :'$ref', :Service
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
        key :tags, ['service']
        key :description, 'Creates a new service belong to a specified company'
        key :operationId, 'addServiceByCompany'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'Details of the service to be created'
          key :required, true
          schema do
            key :'$ref', :ServiceInput
          end
        end
        response 201 do
          key :description, 'OK, Services is successfully created'
          schema do
            key :'$ref', :Service
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

    swagger_path '/api/v1/services/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of service'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :put do
        security do
          key :Authorization, []
        end
        key :tags, ['service']
        key :description, 'Update a service'
        key :operationId, 'updateService'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'New details of the service to be updated'
          key :required, true
          schema do
            key :'$ref', :ServiceInput
          end
        end
        response 200 do
          schema do
            key :'$ref', :Service
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
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, ['service']
        key :description, 'Returns a service'
        key :operationId, 'findServiceById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, Service of the given ID is fetched'
          schema do
            key :'$ref', :Service
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
        key :tags, ['service']
        key :description, 'Deletes a single service'
        key :operationId, 'deleteService'
        response 204 do
          key :description, 'No content success. Service of the given ID is deleted'
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
