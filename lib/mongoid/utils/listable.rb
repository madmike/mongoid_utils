module Mongoid
  module Utils
    module Listable
      extend ActiveSupport::Concern

      included do
        has_and_belongs_to_many :lists, inverse_of: nil
        after_update -> { @hash = nil }

        index({ list_ids: 1 }, { sparse: true, name: "lists_index" })
      end

      def lists_hash
    #    @hash ||= Hash[lists.map { |list| [list.model_name.param_key.to_sym, list] }]#.group_by(&:first).map { |k,v| {k => (el = v.map(&:last)).length > 1 ? el : el[0]} }.last || {}
        unless @hash
          hashes = lists.map{ |list| Hash[*[list.model_name.param_key.to_sym, list]] }
          @hash ||= hashes.flat_map(&:entries).group_by(&:first).map{|k,v| Hash[k, v.map(&:last)]}.reduce(Hash.new, :merge) || {}
          @hash.each {|k,v| if v.length == 1 then @hash[k] = v.first end}
                    #hashes.inject{ |h1,h2| h1.merge(h2){ |*a| a[1,2] } } || {}
        end

        @hash
      end

      def list_title(list)
    #    lists_hash[list].is_a?(Array) ? lists_hash[list].collect(&:title).join(', ') : lists_hash[list].try(:title)
        if lists_hash[list].is_a?(Array)
          lists_hash[list].map { |l|
            l.is_a?(Array) ? l.collect(&:title).join(', ') : l.try(:title)
          }
        else
          lists_hash[list].try(:title)
        end
      end

      def update_lists(new_lists)
        _lists = self.lists

        new_lists.each do |new_list|
          _lists = _lists.delete_if { |list| list.is_a? new_list.class }
        end

        self.lists = (_lists + new_lists)
      end
    end
  end
end