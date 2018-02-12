module RenderErrors
  def render_bad_request(error)
    payload = {
      status: 400,
      error: error
    }
    render json: payload, status: :bad_request
  end

  def render_id_not_found
    payload = {
      status: 404,
      error: 'No resource with given ID found.'
    }
    render json: payload, status: 404
  end

  def doorkeeper_unauthorized_render_options(*)
    {
      json: {
        error: "Invalid or missing access token. Please sign in/sign up first.",
        "status_code": "401"
      }
    }
  end
end