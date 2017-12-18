class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :update, :destroy]

  include Swagger::Blocks

  swagger_path '/companies/{company_id}/services' do
    operation :get do
      key :tags, ['service']
      key :description, 'Returns list of all services from specified company'
      key :operationId, 'findServicesByCompany'
      key :produces, [
        'application/json'
      ]
      response 200 do
        schema type: :array do
          items do
            key :'$ref', :Service
          end
        end
      end
    end
    operation :post do
      key :tags, ['service']
      key :description, 'Creates a new service belonging to specified company'
      key :operationId, 'addServiceByCompany'
      key :produces, [
        'application/json'
      ]
      parameter do
        key :name, :service
        key :in, :body
        key :description, 'Service to create'
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
          key :'$ref', :SwaggerErrorModel
        end
      end
    end
  end

  swagger_path '/services/{id}' do
    parameter do
      key :name, :id
      key :in, :path
      key :description, 'ID of service'
      key :required, true
      key :type, :integer
      key :format, :int64
    end
    operation :put do
      key :tags, ['service']
      key :description, 'Update a service'
      key :operationId, 'updateService'
      key :produces, [
        'application/json'
      ]
      parameter do
        key :name, :service
        key :in, :body
        key :description, 'Service to update'
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
          key :'$ref', :SwaggerErrorModel
        end
      end
    end
    operation :get do
      key :tags, ['service']
      key :description, 'Returns a service'
      key :operationId, 'findServiceById'
      key :produces, [
        'application/json'
      ]
      response 200 do
        schema do
          key :'$ref', :Service
        end
      end
    end
    operation :delete do
      key :tags, ['service']
      key :description, 'Deletes a single service'
      key :operationId, 'deleteService'
      response 204
    end
  end

  # GET /companies/:company_id/services
  def index
    @services = Service.where(company_id: params[:company_id])

    render json: @services
  end

  # GET /services/1
  def show
    render json: @service
  end

  # POST /companies/:company_id/services
  def create
    @service = Service.new(service_params)

    if @service.save
      render json: @service, status: :created, location: @service
    else
      render json: @service.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /services/1
  def update
    if @service.update(service_params)
      render json: @service
    else
      render json: @service.errors, status: :unprocessable_entity
    end
  end

  # DELETE /services/1
  def destroy
    @service.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def service_params
      params.require(:service).permit(:name, :description, :company_id)
    end
end
