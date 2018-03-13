module SwaggerDocs::Grant
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks

    # example :Grant do
    #   key :strength, ["Quality Tools & Materials", "Skillful & Knowledgeable"]
    # end

    swagger_schema :Grant do
      key :type, :object
      key :required, [:id, :name, :acronym, :description, :user]

      property :id do
        key :type, :integer
        key :format, :int64
      end

      property :name do
        key :type, :string
        key :example, 'Operation & Technology Roadmapping'
      end

      property :acronym do
        key :type, :string
        key :example, 'OTR'
      end

      property :description do
        key :type, :string
        key :example, 'Want to maximise returns from your investments in technology?
                       Get a grant for expert help from A*STAR to create a technology roadmap.'
      end

      property :user do
        key :'$ref', :User
      end
    end

    swagger_schema :ReviewGrant do
      key :type, :object
      key :required, [:id, :name, :acronym, :description, :user]

      property :id do
        key :type, :integer
        key :format, :int64
      end

      property :name do
        key :type, :string
        key :example, 'Operation & Technology Roadmapping'
      end

      property :acronym do
        key :type, :string
        key :example, 'OTR'
      end

      property :description do
        key :type, :string
        key :example, 'Want to maximise returns from your investments in technology? Get a grant for expert help from A*STAR to create a technology roadmap.'
      end
    end

    swagger_schema :GrantInput do
      allOf do
        schema do
          property :grant do
            key :type, :object
            property :name do
              key :type, :string
            end
            property :description do
              key :type, :string
            end
            property :acronym do
              key :type, :string
            end
            property :user_id do
              key :type, :integer
              key :format, :int64
            end
          end
        end
      end
    end
  end
end
