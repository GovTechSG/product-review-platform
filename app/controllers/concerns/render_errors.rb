module RenderErrors
  def render_bad_request(error)
    payload = {
      status: 400,
      error: error
    }
    render json: payload, status: :bad_request
  end
end
