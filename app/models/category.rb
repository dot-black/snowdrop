class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  validates :title, :image, presence: true
  validates_format_of :title, with: /\A[\w\s\']+\z/
  mount_uploader :image, CategoryImageUploader
  default_scope { order( id: :desc ) }
  scope :visible, -> { where( visible: true ).order( created_at: :desc ) }
  scope :hidden, -> { where( visible: false ).order( created_at: :desc ) }
end
