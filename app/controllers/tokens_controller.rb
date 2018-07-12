class TokensController < Doorkeeper::TokensController
  include SwaggerDocs::Tokens
  def url_options
    {}
  end

  def create
    params[:grant_type] = "password"
    app = App.find_for_authentication(name: params[:name])
    params[:scope] = app.scopes.first if app && app.presence?
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
          "#{I18n.t('token.key')}": [I18n.t('token.invalid')]
      }, status: 404
    end
  end

  def refresh
    if token.present? && token.accessible?
      token.revoke
      create
    else
      render json: {
          "#{I18n.t('token.key')}": [I18n.t('token.not_found')]
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
          "#{I18n.t('token.key')}": [I18n.t('token.inaccessible')]
      }, status: 404
    end
  end
end