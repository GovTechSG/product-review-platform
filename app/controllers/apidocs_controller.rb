class ApidocsController < ApplicationController
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Product Review Platform'
      key :description, 'API for GDS Product Review Platform'
      contact do
        key :name, 'Government Digital Services'
      end
      license do
        key :name, 'MIT'
      end
    end
    key :host, "#{ENV['SWAGGER_API_BASE_PATH']}"
    key :consumes, ['application/json']
    key :produces, ['application/json']

    security_definition :Authorization do
      key :type, :apiKey
      key :name, "Authorization"
      key :in, :header
      key :description, 'Enter "Bearer " before ur access key'
    end
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    App,
    TokensController,
    CompaniesController,
    Company,
    UsersController,
    User,
    ProductsController,
    Product,
    ServicesController,
    Service,
    ReviewsController,
    Review,
    CommentsController,
    Comment,
    LikesController,
    Like,
    Industry,
    IndustriesController,
    StatisticsController,
    self
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
