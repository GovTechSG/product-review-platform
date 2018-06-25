module Statistics::ProductsAndServices
  extend ActiveSupport::Concern

  included do
    def company_name
      self.company.name
    end
  end
end