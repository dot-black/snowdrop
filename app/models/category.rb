class Category < ApplicationRecord
  attribute :title
  attribute :slug
  attribute :image

  has_many :products, dependent: :destroy
  validates :title, :slug, :image, presence: true
  validates_format_of :slug, with: /\A[[a-z]\s\']+\z/
  validates :slug, uniqueness: { case_sensitive: false }
  mount_uploader :image, CategoryImageUploader
  default_scope { order( id: :desc ) }
  scope :visible, -> { where( visible: true ).order( created_at: :desc ) }
  scope :hidden, -> { where( visible: false ).order( created_at: :desc ) }
  translates :title
end
