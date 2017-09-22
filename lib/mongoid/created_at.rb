module Mongoid
  module Timestamps
    module CreatedAt
      # Returns the creation time calculated from ObjectID
      #
      # @return [ Date ] the creation time
      def created_at
        read_attribute(:created_at) || id.generation_time.to_datetime
      end

      # Set generation time of ObjectId.
      # Note: This will modify the ObjectId and
      # is therefor only useful for not persisted documents
      #
      # @return [ BSON::ObjectId ] the generated object id
#       def created_at=(date)
#         self.id = BSON::ObjectId.from_time(date)
#       end
    end
  end
end