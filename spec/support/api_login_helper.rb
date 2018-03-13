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
    token: ["Invalid or missing access token. Please sign in/sign up first."]
  }.with_indifferent_access
end

def wrong_credentials_response
  {
    token: ["Missing or invalid credentials."]
  }.with_indifferent_access
end

def incorrect_token_response
  {
    token: ["Invalid token."]
  }.with_indifferent_access
end

def revoked_token_response
  {
    token: ["Inaccessible token. May have already been revoked."]
  }.with_indifferent_access
end

def refresh_wrong_parameter_response
  {
    token: ["Invalid or missing token/credentials. Please include token in request header and credentials in request body"]
  }.with_indifferent_access
end

def refresh_no_header_response
  {
    token: ["Invalid or missing token/credentials. Please include token in request header and credentials in request body"]
  }.with_indifferent_access
end