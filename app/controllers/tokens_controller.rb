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
        error: "Invalid token.",
        "status_code": "404"
      }, status: 404
    end
  end

  def refresh
    if request.headers["Authorization"] != nil && 
                                           params.has_key?(:password) &&
                                           params.has_key?(:name)
      request.POST['token'] = request.headers["Authorization"].split(' ')[1]
      if token.present? && token.accessible?
        token.revoke
        create
      else
        render json: {
          error: "Invalid or missing token/credentials. Please include token in request header and credentials in request body",
          "status_code": "401"
        }, status: 401
      end
    else
      render json: {
          error: "Invalid or missing token/credentials. Please include token in request header and credentials in request body",
          "status_code": "401"
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
        error: "Inaccessible token. May have already been revoked.",
        "status_code": "404"
      }, status: 404
    end
  end
end