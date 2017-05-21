class Order < ApplicationRecord
  enum payment_method: { exchanging: 0, provisioning: 1 }
  validates :name, :payment_method, presence: true
  has_many :line_items, dependent: :destroy
end
