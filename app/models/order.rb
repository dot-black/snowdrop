class Order < ApplicationRecord
  enum status: { pending: 0, accepted: 1, declined: 2, completed: 3 }
  validates :comment, length: { maximum: 500 }
  has_many :line_items, dependent: :destroy
  belongs_to :user
  scope :by_status, -> (status) {
    status == "all" ? order(created_at: :desc) : where(status: status).order(created_at: :desc)
  }
  paginates_per 20

  def add_line_items_from_cart(cart)
    cart.line_items.each do |line_item|
      line_item.cart_id = nil
      line_items << line_item
    end
  end
end
