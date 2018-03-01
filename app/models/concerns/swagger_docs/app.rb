module SwaggerDocs::App
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    swagger_schema :Token do
      key :type, :object
      key :required, [:name, :password]

      property :access_token do
        key :type, :string
        key :example, 'abCdEfgHIJKlmnOpQrSTUvWXyzJIUzI1NiJ9.eyJpc3MiOiJwcm9kdWN0X3Jldmlld1
9wbGF0Zm9ybSIsImlhdCI6MTUxOTcwMjk0MCwianRpIjoiNjJkOWIyNzYtNDdhNi00NjY5LThhYmItMWMxNjY5Zj
MwMzZlIiwiYXBwIjp7ImlkIjoxLCJuYW1lIjoiYmdwIn19.wVEqsnbJ99eRem4claAwJfZV82ddzRCzYJouJCQGpM0'
      end

      property :token_type do
        key :type, :string
        key :example, 'Bearer'
      end

      property :created_at do
        key :type, :integer
        key :example, 1519702940
      end
    end

    swagger_schema :TokenInput do
      allOf do
        schema do
          property :name do
            key :type, :string
          end

          property :password do
            key :type, :string
          end
        end
      end
    end

    swagger_schema :TokenRefreshInput do
      allOf do
        schema do
          property :token do
            key :type, :string
          end

          property :name do
            key :type, :string
          end

          property :password do
            key :type, :string
          end
        end
      end
    end

    swagger_schema :TokenSignoutInput do
      allOf do
        schema do
          property :token do
            key :type, :string
          end
        end
      end
    end
  end
end
