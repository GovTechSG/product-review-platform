module RenderErrors
  def render_error(status, *errors)
    payload = {}
    if errors.empty?
      payload = case status
                when 400
                  { "#{I18n.t('general_error.key')}": [I18n.t('general_error.bad_request')] }
                when 404
                  { "#{I18n.t('general_error.key')}": [I18n.t('general_error.not_found')] }
                when 422
                  { "#{I18n.t('general_error.key')}": [I18n.t('general_error.unprocessable_entity')] }
                when 401
                  { "#{I18n.t('general_error.key')}": [I18n.t('general_error.unauthorized')] }
                else
                  { "#{I18n.t('general_error.key')}": [I18n.t('general_error.unexpected')] }
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
        "#{I18n.t('token.key')}": [I18n.t('token.not_authorized')]
      }
    }
  end
end