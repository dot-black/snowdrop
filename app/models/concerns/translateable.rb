module Translateable
  extend ActiveSupport::Concern
  included do
    def self.translate attributes
      attributes.each do |attribute|
        define_method attribute do
          translations.find_by(locale: I18n.locale, attribute_name: attribute).try(:value) || super
        end
        I18n.available_locales.each do |locale|
          define_method "#{attribute}_#{locale}" do
            translations.find_by(locale: locale, attribute_name: attribute).try(:value)
          end
        end
      end
    end
  end
end
