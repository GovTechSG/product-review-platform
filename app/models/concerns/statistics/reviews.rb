module Statistics::Reviews
  extend ActiveSupport::Concern

  included do
    def likes_count
      self.likes.count
    end

    def comments_count
      self.comments.count
    end
  end
end
