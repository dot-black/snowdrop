class Translation < ApplicationRecord
  belongs_to :translateable, polymorphic: true
  validates :attribute_name, uniqueness: { scope: [:translateable_id, :translateable_type, :locale] }
end
