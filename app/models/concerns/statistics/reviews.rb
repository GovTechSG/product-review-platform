module Statistics::Reviews
  extend ActiveSupport::Concern

  included do
    def likes_count
      self.likes.kept.count
    end

    def comments_count
      self.comments.kept.count
    end
  end
end
