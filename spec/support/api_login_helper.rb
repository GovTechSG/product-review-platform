def login
  authorized_app = create(:app)
  @app_params = {
    "password": authorized_app.password,
    "name": authorized_app.name
  }.as_json
  post oauth_sign_in_path, params: @app_params
  env ||= {}
  env['Authorization'] = "Bearer " + JSON.parse(response.body)["access_token"]
  env
end

def unauthorized_response
  {
    error: "Invalid or missing access token. Please sign in/sign up first.",
    "status_code": "401"
  }
end

def wrong_credentials_response
  {
    error: "Missing or invalid credentials.",
    "status_code": "401"
  }
end