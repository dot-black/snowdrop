module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filterning_params)
      results = self.where nil
      filterning_params.each do |key, value|
        results = results.public_send(key, value) if value.present?
      end
      results
    end
  end
end
