class User < ApplicationRecord
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of     :email, with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  has_many :orders
  has_many :user_informations
  paginates_per 20
end
