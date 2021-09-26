require 'active_support/concern'

module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter_by(filters)
      results = all
      filters.each do |k, v|
        results = results.where("#{k} = ?", v) unless v.blank?
      end
      results
    end
  end
end
