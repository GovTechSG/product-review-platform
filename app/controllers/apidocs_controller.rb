class ApidocsController < ApplicationController
  include Swagger::Blocks

  swagger_root do
    key :swagger, "#{I18n.t('swagger_ui.swagger_version')}"
    info do
      key :version, "#{I18n.t('swagger_ui.endpoint_version')}"
      key :title, "#{I18n.t('swagger_ui.title')}"
      key :description, "#{I18n.t('swagger_ui.description')}"
      contact do
        key :name, "#{I18n.t('swagger_ui.contact_name')}"
      end
      license do
        key :name, "#{I18n.t('swagger_ui.license_name')}"
      end
    end
    key :host, "#{ENV['SWAGGER_API_BASE_PATH']}"
    key :consumes, ['application/json']
    key :produces, ['application/json']

    security_definition :Authorization do
      key :type, :apiKey
      key :name, "Authorization"
      key :in, :header
      key :description, "#{I18n.t('swagger_ui.authorization_description')}"
    end
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    App,
    TokensController,
    CompaniesController,
    Company,
    AgenciesController,
    Agency,
    ProductsController,
    Product,
    ServicesController,
    Service,
    ProjectsController,
    Project,
    ReviewsController,
    Review,
    CommentsController,
    Comment,
    LikesController,
    Like,
    Industry,
    IndustriesController,
    Grant,
    GrantsController,
    Aspect,
    AspectsController,
    StatisticsController,
    self
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
