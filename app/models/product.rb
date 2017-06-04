class Product < ApplicationRecord
  enum size: { XS: 1, S: 2, M: 3, L: 4, XL: 5 }
  enum priority: { Hi: 1, Mid: 2, Low: 3 }
  validates :title, :description, presence: true
  # validates :title, uniqueness: true
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
  scope :visible, -> { where( visible: true ) }
  scope :hiden, -> { where( visible: false ) }
  scope :archival, -> { where( archive: true ) }

  def remove_image_at_index(index)
    remain_images = self.images # copy the array
    remain_images.delete_at(index) # delete the target image
    # deleted_image.try(:remove!) # delete image from S3
    self.images = remain_images # re-assign back
  end


  private

  def remove_zero_sizes
    self.sizes.delete(0)
  end

end
