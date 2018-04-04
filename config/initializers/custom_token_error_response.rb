module CustomTokenErrorResponse
  def body
    {
      "#{I18n.t('token.key')}": [I18n.t('token.login_failed')]
    }
    # or merge with existing values by
    # super.merge({key: value})
  end
end
