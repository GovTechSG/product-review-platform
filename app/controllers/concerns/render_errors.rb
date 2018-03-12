module RenderErrors
  def render_error(status, *errors)
    payload = {}
    if errors.empty?
      payload = case status
                when 400
                  { "Bad request": ["Missing parameters."] }
                when 404
                  { "id": ["Not found."] }
                when 422
                  { "Unprocessable entity": ["Invalid parameters."] }
                when 401
                  { "Unauthorized": ["Please provide valid credentials"] }
                else
                  { "Unexpected": ["Please contact admin"] }
                end
    else
      errors.each do |error|
        payload = payload.merge(error)
      end
    end
    render json: payload, status: status
  end

  def doorkeeper_unauthorized_render_options(*)
    {
      json: {
        error: ["Invalid or missing access token. Please sign in/sign up first."]
      }
    }
  end
end