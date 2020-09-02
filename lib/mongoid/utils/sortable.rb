module Mongoid
  module Utils
    module Sortable
      extend ActiveSupport::Concern

      included do
        scope :fresh, -> { order_by(_id: :desc) }
      end

      module ClassMethods
        def fresh_by(param)
          range = case param
            when 'day'; 24.hours.ago..Time.now
            when 'week'; 7.days.ago..Time.now
            when 'month'; 30.days.ago..Time.now
            when 'year'; 365.days.ago..Time.now
          end

          between(:id.in => BSON::ObjectId.from_time(range.first)..BSON::ObjectId.from_time(range.last)).order_by(_id: :desc)
        end
      end
    end
  end
end