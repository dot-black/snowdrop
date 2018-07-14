module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filterning_params)
      results = all
      filterning_params.each do |key, value|
        results = results.public_send("filter_#{key}", value) if value.present?
      end
      results
    end
  end
end
