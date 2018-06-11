source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'activeadmin'
gem 'active_model_serializers'
gem 'carrierwave'
gem 'clamby'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'doorkeeper'
gem 'doorkeeper-jwt'
gem 'discard', '~> 1.0'
gem 'devise'
gem 'email_validator'
gem 'fog', '~> 1.38.0'
gem 'file_validators'
gem 'letter_avatar'
gem 'mini_magick'
gem 'rails', '~> 5.2.0'
gem 'ransack'
gem 'rubocop', '0.52.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use Figaro to store secrets and env variables
gem 'figaro'
gem 'valid_url'
# Generate swagger documentation
gem 'swagger-blocks'
gem 'simplecov', require: false, group: :test

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', require: 'rack/cors'

# Used to obfuscate IDs
gem "hashid-rails"


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Gems for ruby debugging
  gem 'database_cleaner'
  gem 'debase', '0.2.2.beta10'
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'ruby-debug-ide', '0.6.0'
  gem 'rspec-rails'
  gem 'rspec-teamcity', '~> 0.0.1', require: false
  gem 'rubocop-teamcity-formatter', git: 'https://github.com/govtechsg/rubocop-teamcity-formatter.git', require: false
end

group :qa do
  gem 'factory_bot_rails'
  gem 'ffaker'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
