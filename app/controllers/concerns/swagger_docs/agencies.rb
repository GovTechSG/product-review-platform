module SwaggerDocs::Agencies
  extend ActiveSupport::Concern

  included do

    include Swagger::Blocks

    swagger_path '/agencies' do
      operation :get do
        key :tags, ['agency']
        key :description, 'Returns list of all agencies'
        key :operationId, 'findAgencies'
        key :produces, [
            'application/json'
        ]
        response 200 do
          schema type: :array do
            items do
              key :'$ref', :Agency
            end
          end
        end
      end
      operation :post do
        key :tags, ['agency']
        key :description, 'Creates a new agency'
        key :operationId, 'addAgency'
        key :produces, [
            'application/json'
        ]
        parameter do
          key :name, :agency
          key :in, :body
          key :description, 'Agency to create'
          key :required, true
          schema do
            key :'$ref', :AgencyInput
          end
        end
        response 200 do
          schema do
            key :'$ref', :Agency
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

    swagger_path '/agencies/{id}' do
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of agency'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      operation :put do
        key :tags, ['agency']
        key :description, 'Update an agency'
        key :operationId, 'updateAgency'
        key :produces, [
            'application/json'
        ]
        parameter do
          key :name, :agency
          key :in, :body
          key :description, 'Agency to update'
          key :required, true
          schema do
            key :'$ref', :AgencyInput
          end
        end
        response 200 do
          schema do
            key :'$ref', :Agency
          end
        end
        response 422 do
          key :description, 'Unprocessable Entity'
          schema do
            key :'$ref', :SwaggerError
          end
        end
      end
      operation :get do
        key :tags, ['agency']
        key :description, 'Returns an agency'
        key :operationId, 'findAgencyById'
        key :produces, [
            'application/json'
        ]
        response 200 do
          schema do
            key :'$ref', :Agency
          end
        end
      end
      operation :delete do
        key :tags, ['agency']
        key :description, 'Deletes a single agency'
        key :operationId, 'deleteAgency'
        response 204
      end
    end
  end
end
