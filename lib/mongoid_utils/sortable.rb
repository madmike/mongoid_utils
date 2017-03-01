module Mongoid::Sortable
  extend ActiveSupport::Concern

  included do
    scope :fresh, -> { order_by(_id: :desc) }
  end

  module ClassMethods
    def fresh_by(param)
      range = case param
        when 'day'; Time.now.at_beginning_of_day..Time.now
        when 'week'; Time.now.at_beginning_of_week..Time.now
        when 'month'; Time.now.at_beginning_of_month..Time.now
        when 'year'; Time.now.at_beginning_of_year..Time.now
      end

      between(:id.in => BSON::ObjectId.from_time(range.first)..BSON::ObjectId.from_time(range.last))
    end
  end
end