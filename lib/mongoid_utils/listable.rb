module Mongoid::Listable
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
      @hash ||= hashes.inject{ |h1,h2| h1.merge(h2){ |*a| a[1,2] } } || {}
    end

    @hash
  end

  def list_title(list)
    lists_hash[list].is_a?(Array) ? lists_hash[list].collect(&:title).join(', ') : lists_hash[list].try(:title)
  end
end