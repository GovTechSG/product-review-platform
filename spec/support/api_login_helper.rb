def request_login
  authorized_app = create(:app)
  app_params = {
    "password": authorized_app.password,
    "name": authorized_app.name
  }.as_json
  post oauth_sign_in_path, params: app_params
  env ||= {}
  env['Authorization'] = "Bearer " + JSON.parse(response.body)["access_token"]
  env
end

def controller_login
  authorized_app = create(:app)
  app_params = {
    "password": authorized_app.password,
    "name": authorized_app.name
  }
  post :create, params: app_params
  JSON.parse(response.body)["access_token"]
end

def unauthorized_response
  {
    "#{I18n.t('token.key')}": [I18n.t('token.not_authorized')]
  }.with_indifferent_access
end

def wrong_credentials_response
  {
    "#{I18n.t('token.key')}": [I18n.t('token.login_failed')]
  }.with_indifferent_access
end

def incorrect_token_response
  {
    "#{I18n.t('token.key')}": [I18n.t('token.invalid')]
  }.with_indifferent_access
end

def revoked_token_response
  {
    "#{I18n.t('token.key')}": [I18n.t('token.inaccessible')]
  }.with_indifferent_access
end

def refresh_wrong_parameter_response
  {
    "#{I18n.t('token.key')}": [I18n.t('token.not_found')]
  }.with_indifferent_access
end

def refresh_no_header_response
  {
    "#{I18n.t('token.key')}": [I18n.t('token.not_found')]
  }.with_indifferent_access
end