class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  attribute :title
  attribute :slug
  attribute :image
  translates :title
  mount_uploader :image, CategoryImageUploader

  validates :title, :slug, :image, presence: true
  validates_format_of :slug, with: /\A[[a-z]\s\']+\z/
  validates :slug, uniqueness: { case_sensitive: false }

  default_scope { order id: :desc }
  scope :visible, -> { where(visible: true).order created_at: :desc  }
  scope :hidden,  -> { where(visible: false).order created_at: :desc }
end
