class TokensController < Doorkeeper::TokensController
  def url_options
    return {}
  end
end