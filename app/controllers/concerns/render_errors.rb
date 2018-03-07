module RenderErrors
  def render_error(status, error = nil)
    if error.nil?
      error = case status
              when 400
                "Bad request, missing parameters."
              when 404
                "No resource with given ID found."
              when 422
                "Unprocessable entity, invalid parameters"
              when 401
                "Unauthorized. Please provide valid credentials"
              else
                "Unexpected error"
              end
    end
    payload = {
      error: error
    }
    render json: payload, status: status
  end

  def doorkeeper_unauthorized_render_options(*)
    {
      json: {
        error: "Invalid or missing access token. Please sign in/sign up first."
      }
    }
  end
end