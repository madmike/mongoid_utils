module Mongoid
  module Utils
    class Comment
      include Mongoid::Document

      default_scope -> { order_by(_id: :desc) }

      belongs_to :user
      belongs_to :commentable, polymorphic: true, counter_cache: :comments_count

      field :text, type: String
    end
  end
end