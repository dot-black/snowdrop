class Order < ApplicationRecord
  enum status: { pending: 0, shipped: 1, expired: 2, canceled: 4 }
  validates :name, :email, presence: true
  has_many :line_items, dependent: :destroy
  scope :by_status, -> (status) { where( status: status ) }
  paginates_per 20

  def add_line_items_from_cart(cart)
    cart.line_items.each do |line_item|
      line_item.cart_id = nil
      line_items << line_item
    end
  end
end
