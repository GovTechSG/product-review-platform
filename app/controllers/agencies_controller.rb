class AgenciesController < ApplicationController
  before_action :set_agency, only: [:show, :update, :destroy]

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
          key :'$ref', :SwaggerErrorModel
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
          key :'$ref', :SwaggerErrorModel
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

  # GET /agencies
  def index
    @agencies = Agency.all

    render json: @agencies
  end

  # GET /agencies/1
  def show
    render json: @agency
  end

  # POST /agencies
  def create
    @agency = Agency.new(agency_params)

    if @agency.save
      render json: @agency, status: :created, location: @agency
    else
      render json: @agency.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /agencies/1
  def update
    if @agency.update(agency_params)
      render json: @agency
    else
      render json: @agency.errors, status: :unprocessable_entity
    end
  end

  # DELETE /agencies/1
  def destroy
    @agency.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agency
      @agency = Agency.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def agency_params
      params.require(:agency).permit(:name, :email, :number)
    end
end
