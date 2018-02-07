class TokensController < Doorkeeper::TokensController
  def url_options
    {}
  end

  def create
    params[:grant_type] = "password"
    response = authorize_response
    headers.merge! response.headers
    self.response_body = response.body.to_json
    self.status = response.status
  rescue Errors::DoorkeeperError => e
    handle_token_exception e
  end
end