def request_login
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

def controller_login
  authorized_app = create(:app)
  @app_params = {
    "password": authorized_app.password,
    "name": authorized_app.name
  }
  post :create, params: @app_params
  JSON.parse(response.body)["access_token"]
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

def incorrect_token_response
  {
    error: "Invalid token.",
    "status_code": "404"
  }
end

def revoked_token_response
  {
    error: "Inaccessible token. May have already been revoked.",
    "status_code": "404"
  }
end

def refresh_wrong_parameter_response
  {
    error: "Invalid or missing token/credentials. Please include token in request header and credentials in request body",
    "status_code": "401"
  }
end

def refresh_no_header_response
  {
    error: "Invalid or missing token/credentials. Please include token in request header and credentials in request body",
    "status_code": "401"
  }
end