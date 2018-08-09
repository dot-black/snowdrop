class Translation < ApplicationRecord
  belongs_to :translateable, polymorphic: true
  validates :locale, :attribute_name, uniqueness: { scope: [:translateable_id, :translateable_type] }
end
