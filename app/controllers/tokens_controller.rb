class TokensController < Doorkeeper::TokensController
  include SwaggerDocs::Tokens
  def url_options
    {}
  end

  def create
    params[:grant_type] = "password"
    response = authorize_response
    headers.merge! response.headers
    self.response_body = response.body.to_json
    self.status = response.status
  rescue Doorkeeper::Errors::DoorkeeperError => e
    handle_token_exception e
  end

  def revoke
    # The authorization server, if applicable, first authenticates the client
    # and checks its ownership of the provided token.
    #
    # Doorkeeper does not use the token_type_hint logic described in the
    # RFC 7009 due to the refresh token implementation that is a field in
    # the access token model.
    if authorized?
      revoke_token
    else
      render json: {
        token: ["Invalid token."]
      }, status: 404
    end
  end

  def refresh
    if token.present? && token.accessible?
      token.revoke
      create
    else
      render json: {
        token: ["Invalid or missing token/credentials. Please include token in request header and credentials in request body"]
      }, status: 401
    end
  end
  
  private

  def revoke_token
    if token.accessible?
      token.revoke
      render json: {}, status: 200
    else
      render json: {
        token: ["Inaccessible token. May have already been revoked."]
      }, status: 404
    end
  end
end