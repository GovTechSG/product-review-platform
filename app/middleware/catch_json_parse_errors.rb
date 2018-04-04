class CatchJsonParseErrors
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue ActionDispatch::Http::Parameters::ParseError => error
    error_output = [I18n.t('general_error.json_error_value', error: error)]
    return [
      400, { "Content-Type" => "application/json" },
      [{ "#{I18n.t('general_error.json_error_key')}": error_output }.to_json]
    ]
  end
end