module Mongoid::Hitable
  extend ActiveSupport::Concern

  included do
    scope :popular, -> {order_by(hits_count: :desc)}

    has_many :hits, as: :hitable, dependent: :destroy
    field :hits_count, type: Integer, default: 0
  end

  def hitted(hit_digest)
    seen = hits.where(digest: hit_digest).count > 0

    unless seen
      hits.create(digest: hit_digest)
      self.update_attribute(:hits_count, hits_count + 1)
    end
  end

#   def hit_count(options={})
#     options.reverse_merge!(filter: :session_hash, start_date: nil, end_date: Time.now)
#     hts = options[:start_date].blank? ? hits : hits.between(created_at: options[:start_date]..options[:end_date])
#
#     distinct = options[:filter] != :all
#     distinct ? hts.where(options[:filter].ne => nil).distinct(options[:filter]).count : hts.count
#   end

  module ClassMethods
    def popular_by(param, options = {})
      range = case param
        when 'day'; Time.now.at_beginning_of_day..Time.now
        when 'week'; Time.now.at_beginning_of_week..Time.now
        when 'month'; Time.now.at_beginning_of_month..Time.now
        when 'year'; Time.now.at_beginning_of_year..Time.now
      end

      filter = []
      filter << { :$match => {hitable_type: self.name, _id: {:$gte => BSON::ObjectId.from_time(range.first), :$lte => BSON::ObjectId.from_time(range.last)} } }
      filter << { :$group => {_id: '$hitable_id', count: {:$sum => 1}} }
#      filter << { :$sort => {count: -1} }
      filter << { :$limit => options[:limit].to_i } if options.key?(:limit)

      ids = Hit.collection.aggregate(filter).collect { |raw| raw[:_id] }
      where(:id.in => ids)
    end
  end
end