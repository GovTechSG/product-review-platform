class SwaggerError
  include Swagger::Blocks

  swagger_schema :SwaggerError do
    key :required, [:error]
    property :error do
      key :type, :string
    end
  end
end
