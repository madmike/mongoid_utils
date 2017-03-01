class Hit
  include Mongoid::Document

  belongs_to :hitable, polymorphic: true

  field :digest, type: BSON::Binary
  field :hitable_id, type: BSON::ObjectId
  field :hitable_type, type: String
end