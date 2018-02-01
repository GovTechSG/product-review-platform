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

    security_definition :access_token do
      key :type, :apiKey
      key :name, "access-token"
      key :in, :header
    end

    security_definition :uid do
      key :type, :apiKey
      key :name, :uid
      key :in, :header
    end

    security_definition :client do
      key :type, :apiKey
      key :name, :client
      key :in, :header
    end

    security do
      key :access_token, []
      key :uid, []
      key :client, []
    end
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    CompaniesController,
    Company,
    AgenciesController,
    Agency,
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
    StatisticsController,
    self
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end