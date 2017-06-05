class Product < ApplicationRecord
  enum size: { xs: 1, s: 2, m: 3, l: 4, xl: 5 }
  enum priority: { hi: 1, mod: 2, low: 3 }
  validates :title, :description, presence: true
  validates :price, numericality: {
    greater_than_or_equal_to: 0.01,
    message:'incorrect, please enter a value at least greater then 0.01 or equal one'
  }
  has_many :line_items
  has_many :orders, through: :line_items
  mount_uploaders :images, ProductImageUploader
  before_save :remove_zero_sizes
  default_scope { order(priority: :asc)}
  scope :relevant, -> { where( archive: false ) }
  scope :visible, -> { where( visible: true, archive: false ) }
  scope :hiden, -> { where( visible: false, archive: false ) }
  scope :archival, -> { where( archive: true ) }

  private

  def remove_zero_sizes
    self.sizes.delete(0) if self.sizes
  end

end
