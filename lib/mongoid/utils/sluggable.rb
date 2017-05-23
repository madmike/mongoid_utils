module Mongoid::Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :generate_slug

    field :slug, type: String
  end

  def to_param
    slug
  end

  def generate_slug
    self.slug = title.parameterize.strip
  end

  module ClassMethods
    def from_param(param)
     find_by(slug: param)
    end
  end
end