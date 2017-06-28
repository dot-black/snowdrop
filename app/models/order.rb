class Order < ApplicationRecord
  before_save { email.downcase! }
  enum status: { pending: 0, accepted: 1, declined: 2, completed: 3 }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :comment, length: { maximum: 500 }
  validates :telephone, presence: true, numericality: true, length: { in: 9..15 }
  has_many :line_items, dependent: :destroy
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
