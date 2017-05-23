module Mongoid
  module Relations
    module Macros
      module ClassMethods
        alias :__habtm :has_and_belongs_to_many

        def has_and_belongs_to_many(name, options = {}, &block)
          meta = __habtm(name, options, &block)

          if meta.counter_cached?
            counter_field_name = (meta[:counter_cache] == true) ? "#{meta.name}_count" : meta[:counter_cache]
            counter_ids_name = "#{meta.name.to_s.singularize}_ids"

            self.class_eval %Q{
              def #{counter_field_name}
                self.#{counter_ids_name}.count.to_i
              end
            }
          end

          meta
        end
      end
    end
  end
end