class User < ApplicationRecord
  validates_presence_of   :email, :telephone, :name
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of     :email, with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, length: { maximum: 50 }
  validates :telephone, length: { in: 9..20 }
  has_many :orders
end
