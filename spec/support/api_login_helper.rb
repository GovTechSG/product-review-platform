def login
  post oauth_sign_in_path, params: {
    grant_type: "password",
    password: "test12",
    name: "BGP"
  }.to_json, headers: { "Content-Type" => "application/json" }, as: JSON
  env ||= {}
  env['Authorization'] = "Bearer " + JSON.parse(response.body)["access_token"]
  env
end

def unauthorized_response
  {
    error: "Invalid or missing access token. Please sign in/sign up first.",
    "status_code": "401 Unauthorized"
  }
end