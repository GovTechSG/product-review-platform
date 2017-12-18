class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :update, :destroy]

  include Swagger::Blocks

  swagger_path '/companies' do
    operation :get do
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
          key :'$ref', :SwaggerErrorModel
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
      key :description, 'Deletes a single company'
      key :operationId, 'deleteCompany'
      response 204
    end
  end

  # GET /companies
  def index
    @companies = Company.all

    render json: @companies
  end

  # GET /companies/1
  def show
    render json: @company
  end

  # POST /companies
  def create
    @company = Company.new(company_params)

    if @company.save
      render json: @company, status: :created, location: @company
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/1
  def update
    if @company.update(company_params)
      render json: @company
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/1
  def destroy
    @company.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def company_params
      params.require(:company).permit(:name, :UEN, :aggregate_score)
    end
end
