module SwaggerDocs::Agencies
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_path '/api/v1/agencies' do
      operation :get do
        security do
          key :Authorization, []
        end
        key :tags, ['Agency']
        key :description, 'Returns list of all agencies'
        key :operationId, 'findAgencies'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, list of agencies fetched'
          schema type: :array do
            items do
              key :'$ref', :Agency
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
        key :tags, ['Agency']
        key :description, 'Creates a new agency'
        key :operationId, 'addAgency'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'Details of Agency to be created'
          key :required, true
          schema do
            key :'$ref', :AgencyInput
          end
        end
        response 201 do
          key :description, 'OK, Agency is successfully created'
          schema do
            key :'$ref', :Agency
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

    swagger_path '/api/v1/agencies/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of agency'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :put do
        security do
          key :Authorization, []
        end
        key :tags, ['Agency']
        key :description, 'Update an agency'
        key :operationId, 'updateAgency'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :body
          key :in, :body
          key :description, 'New details of Agency to be updated'
          key :required, true
          schema do
            key :'$ref', :AgencyInput
          end
        end
        response 200 do
          key :description, 'OK, Agency is successfully updated'
          schema do
            key :'$ref', :Agency
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
        key :tags, ['Agency']
        key :description, 'Returns an agency'
        key :operationId, 'findAgencyById'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'OK, agency of the given ID fetched'
          schema do
            key :'$ref', :Agency
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
        key :tags, ['Agency']
        key :description, 'Deletes a single agency'
        key :operationId, 'deleteAgency'
        response 204 do
          key :description, 'No content success. Agency of the given ID is deleted'
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
