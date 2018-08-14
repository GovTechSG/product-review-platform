require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"
require './app/middleware/catch_json_parse_errors'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ProductReviewPlatform
  class Application < Rails::Application
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        allowed_origins =
          if ENV['allowed_origins'].present?
            ENV['allowed_origins'].split(',')
          elsif Rails.application.secrets.allowed_origins.present?
            allowed_origins
          else
            ['*']
          end
        origins allowed_origins
        resource '*', :headers => :any,
                      :methods => [:get, :post, :options],
                      :expose => ['Total', 'Per-Page']
      end
    end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.app_generators.scaffold_controller = :scaffold_controller
    config.middleware.use CatchJsonParseErrors
    # added because api has a frontend

    config.middleware.use Rack::MethodOverride
    config.middleware.use ActionDispatch::Flash
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
  end
end
