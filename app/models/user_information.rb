class UserInformation < ApplicationRecord
  validates_presence_of   :telephone, :name
  validates :name, length: { maximum: 50 }
  validates :telephone, length: { in: 9..20 }
  belongs_to :user
end
