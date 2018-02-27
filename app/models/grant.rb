class Grant < ApplicationRecord
  include SwaggerDocs::Grant
  include Discard::Model
end
