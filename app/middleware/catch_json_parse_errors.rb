class CatchJsonParseErrors
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue ActionDispatch::Http::Parameters::ParseError => error
    error_output = ["There was a problem in the JSON you submitted: #{error}"]
    return [
      400, { "Content-Type" => "application/json" },
      [{ "JSON Error": error_output }.to_json]
    ]
  end
end