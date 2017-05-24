module Mongoid
  module Utils
    module Commentable
      extend ActiveSupport::Concern

      included do
        scope :discussable, -> {order_by(comments_count: :desc)}

        has_many :comments, as: :commentable, dependent: :destroy
        field :comments_count, type: Integer, default: 0
      end

      module ClassMethods
        def discussable_by(param, options = {})
          range = case param
            when 'day'; Time.now.at_beginning_of_day..Time.now
            when 'week'; Time.now.at_beginning_of_week..Time.now
            when 'month'; Time.now.at_beginning_of_month..Time.now
            when 'year'; Time.now.at_beginning_of_year..Time.now
          end

          filter = []
          filter << { :$match => {commentable_type: self.name, _id: {:$gte => BSON::ObjectId.from_time(range.first), :$lte => BSON::ObjectId.from_time(range.last)} } }
          filter << { :$group => {_id: '$commentable_id', count: {:$sum => 1}} }
    #      filter << { :$sort => {count: -1} }
          filter << { :$limit => options[:limit].to_i } if options.key?(:limit)

          ids = Comment.collection.aggregate(filter).collect { |raw| raw[:_id] }

          where(:id.in => ids)
        end
      end
    end
  end
end