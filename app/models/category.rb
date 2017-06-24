class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  validates :title, :image, presence: true
  mount_uploader :image, CategoryImageUploader

  scope :visible, -> { where( visible: true ).order( created_at: :desc ) }
  scope :hiden, -> { where( visible: false ).order( created_at: :desc ) }
end
