class UserInformation < ApplicationRecord
  belongs_to :user

  validates_presence_of   :telephone, :name
  validates :name, length: { maximum: 50 }
  validates :telephone, length: { in: 9..20 }

  scope :search_by_name,        -> (query) { where arel_table[:name].lower.matches("#{query}%") }
  scope :search_by_telephone,   -> (query) { where arel_table[:telephone].matches("%#{query}%") }
end
