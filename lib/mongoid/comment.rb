class Comment
  include Mongoid::Document

  default_scope -> { order_by(_id: :desc) }

  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: :comments_count
  mount_uploader :attachment, FileUploader

  field :text, type: String
end