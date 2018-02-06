module RenderErrors
  def render_bad_request(error)
    payload = {
      status: 400,
      error: error
    }
    render json: payload, status: :bad_request
  end

  def doorkeeper_unauthorized_render_options(*)
    {
      json: {
        error: "Invalid or missing access token. Please sign in/sign up first.",
        "status_code": "401 Unauthorized"
      }
    }
  end
end
