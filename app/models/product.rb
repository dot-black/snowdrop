class Product < ApplicationRecord
  validates :title, :description, presence: true
  # validates :title, uniqueness: true
  validates :price, numericality: {
    greater_than_or_equal_to: 0.01,
    message:'incorrect, please enter a value at least greater then 0.01 or equal one'
  }
  has_many :line_items
  has_many :orders, through: :line_items
  mount_uploaders :images, ProductImageUploader

end
